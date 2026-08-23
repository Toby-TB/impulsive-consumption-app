import 'dart:math';

import 'package:drift/drift.dart';

import '../database/database.dart';
import '../repositories/cart_repository.dart';
import '../repositories/coupon_repository.dart';
import '../repositories/exceptions.dart';

/// 结算结果。
class CheckoutResult {
  final int orderId;
  final int payableCents;
  final int discountCents;

  const CheckoutResult({
    required this.orderId,
    required this.payableCents,
    required this.discountCents,
  });
}

/// 单事务原子结算：校验余额 → 扣款写流水 → 生成订单+明细快照 → 清已勾选购物车。
class CheckoutService {
  final AppDatabase _db;

  CheckoutService(this._db);

  Future<CheckoutResult> checkout({
    required List<CartItemWithProduct> items,
    String? couponIdKeyHint, // 预留：按 id 选择
    int? couponId,
  }) async {
    assert(items.isNotEmpty, 'checkout requires non-empty items');
    final selected = items.where((e) => e.item.selected).toList();
    assert(selected.isNotEmpty, 'no selected items');

    return _db.transaction(() async {
      // 1. 金额计算
      var total = 0;
      for (final e in selected) {
        total += e.lineTotalCents;
      }

      // 2. 优惠券校验
      var discount = 0;
      Coupon? usedCoupon;
      if (couponId != null) {
        usedCoupon = await (_db.select(_db.coupons)
              ..where((t) => t.id.equals(couponId)))
            .getSingleOrNull();
        if (usedCoupon == null ||
            !CouponRepository.isUsable(
                usedCoupon, DateTime.now())) {
          throw const CouponNotApplicableException('unavailable or expired');
        }
        discount = CouponRepository.discountFor(usedCoupon, total);
        if (discount <= 0) {
          throw const CouponNotApplicableException('below threshold');
        }
      }
      final payable = total - discount;

      // 3. 扣款（含余额校验，失败即整体回滚）
      final wallet = await _db.select(_db.wallets).getSingle();
      final balanceAfter = wallet.balanceCents - payable;
      if (balanceAfter < 0) {
        throw InsufficientBalanceException(-balanceAfter);
      }
      await (_db.update(_db.wallets)..where((t) => t.id.equals(wallet.id))).write(
        WalletsCompanion(
          balanceCents: Value(balanceAfter),
          totalSpentCents: Value(wallet.totalSpentCents + payable),
        ),
      );
      await _db.into(_db.walletTransactions).insert(
            WalletTransactionsCompanion.insert(
              type: TxType.spend,
              amountCents: -payable,
              balanceAfterCents: balanceAfter,
              refText: Value('order'),
              createdAt: DateTime.now(),
            ),
          );

      // 4. 订单落库
      final now = DateTime.now();
      final orderNo = _generateOrderNo(now);
      final orderId = await _db.into(_db.orders).insert(
            OrdersCompanion.insert(
              orderNo: orderNo,
              status: OrderStatus.pendingShip,
              totalAmountCents: total,
              discountCents: discount,
              payableCents: payable,
              couponId: Value(couponId),
              createdAt: now,
              paidAt: Value(now),
            ),
          );
      for (final e in selected) {
        await _db.into(_db.orderItems).insert(
              OrderItemsCompanion.insert(
                orderId: orderId,
                productId: e.product.id,
                quantity: e.item.quantity,
                unitPriceSnapshotCents: e.product.priceCents,
              ),
            );
        // 模拟库存扣减与销量增长
        await (_db.update(_db.products)
              ..where((t) => t.id.equals(e.product.id)))
            .write(
          ProductsCompanion(
            stock: Value(max(0, e.product.stock - e.item.quantity)),
            sales: Value(e.product.sales + e.item.quantity),
          ),
        );
      }

      // 5. 核销优惠券 & 清除已购购物车项
      if (couponId != null) {
        await (_db.update(_db.coupons)..where((t) => t.id.equals(couponId)))
            .write(const CouponsCompanion(status: Value(CouponStatus.used)));
      }
      for (final e in selected) {
        await (_db.delete(_db.cartItems)
              ..where((t) => t.id.equals(e.item.id)))
            .go();
      }

      return CheckoutResult(
        orderId: orderId,
        payableCents: payable,
        discountCents: discount,
      );
    });
  }

  static String _generateOrderNo(DateTime t) {
    final r = Random();
    final suffix = List.generate(4, (_) => r.nextInt(10)).join();
    final ymd = '${t.year}${t.month.toString().padLeft(2, '0')}'
        '${t.day.toString().padLeft(2, '0')}';
    final hms = '${t.hour.toString().padLeft(2, '0')}'
        '${t.minute.toString().padLeft(2, '0')}'
        '${t.second.toString().padLeft(2, '0')}';
    return 'IC$ymd$hms$suffix';
  }
}
