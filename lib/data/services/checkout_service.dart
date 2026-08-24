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
  final PaymentMethod paymentMethod;
  final int firstInstallmentCents;

  const CheckoutResult({
    required this.orderId,
    required this.payableCents,
    required this.discountCents,
    required this.paymentMethod,
    this.firstInstallmentCents = 0,
  });
}

/// 单事务原子结算：
/// 余额支付：校验余额 → 扣款写流水；
/// 货到付款：不扣款，签收时结算；
/// 分期(3期)：扣首期（向上取整）。
/// 同时生成订单+明细快照、地址快照、清已勾选购物车。
class CheckoutService {
  final AppDatabase _db;

  CheckoutService(this._db);

  Future<CheckoutResult> checkout({
    required List<CartItemWithProduct> items,
    int? couponId,
    AddressesData? address,
    PaymentMethod method = PaymentMethod.balance,
    String? remark,
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
      if (couponId != null) {
        final usedCoupon = await (_db.select(_db.coupons)
              ..where((t) => t.id.equals(couponId)))
            .getSingleOrNull();
        if (usedCoupon == null ||
            !CouponRepository.isUsable(usedCoupon, DateTime.now())) {
          throw const CouponNotApplicableException('unavailable or expired');
        }
        discount = CouponRepository.discountFor(usedCoupon, total);
        if (discount <= 0) {
          throw const CouponNotApplicableException('below threshold');
        }
      }
      final payable = total - discount;

      // 3. 按支付方式处理资金流
      final wallet = await _db.select(_db.wallets).getSingle();
      var settled = true;
      var installmentsPaid = 0;
      var firstInstallment = 0;

      switch (method) {
        case PaymentMethod.balance:
          final balanceAfter = wallet.balanceCents - payable;
          if (balanceAfter < 0) {
            throw InsufficientBalanceException(-balanceAfter);
          }
          await _deduct(
            wallet: wallet,
            balanceAfter: balanceAfter,
            amount: payable,
            ref: 'order',
          );

        case PaymentMethod.cod:
          // 签收时扣款
          settled = false;

        case PaymentMethod.installment3:
          firstInstallment = (payable / 3).ceil();
          final balanceAfter = wallet.balanceCents - firstInstallment;
          if (balanceAfter < 0) {
            throw InsufficientBalanceException(-balanceAfter);
          }
          installmentsPaid = 1;
          await _deduct(
            wallet: wallet,
            balanceAfter: balanceAfter,
            amount: firstInstallment,
            ref: 'installment 1/3',
          );
      }

      // 4. 订单落库（含地址快照）
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
              paymentMethod: Value(method),
              receiverName: Value(address?.name ?? ''),
              receiverPhone: Value(address?.phone ?? ''),
              receiverAddress: Value(
                address == null ? '' : '${address.region} ${address.detail}',
              ),
              remark: Value(remark),
              settled: Value(settled),
              installmentsPaid: Value(installmentsPaid),
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
        await (_db.delete(_db.cartItems)..where((t) => t.id.equals(e.item.id)))
            .go();
      }

      return CheckoutResult(
        orderId: orderId,
        payableCents: payable,
        discountCents: discount,
        paymentMethod: method,
        firstInstallmentCents: firstInstallment,
      );
    });
  }

  Future<void> _deduct({
    required Wallet wallet,
    required int balanceAfter,
    required int amount,
    required String ref,
  }) async {
    await (_db.update(_db.wallets)..where((t) => t.id.equals(wallet.id))).write(
      WalletsCompanion(
        balanceCents: Value(balanceAfter),
        totalSpentCents: Value(wallet.totalSpentCents + amount),
      ),
    );
    await _db.into(_db.walletTransactions).insert(
          WalletTransactionsCompanion.insert(
            type: TxType.spend,
            amountCents: -amount,
            balanceAfterCents: balanceAfter,
            refText: Value(ref),
            createdAt: DateTime.now(),
          ),
        );
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
