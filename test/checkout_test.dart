import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/data/database/database.dart';
import 'package:impulsive_consumption/data/database/seed_loader.dart';
import 'package:impulsive_consumption/data/repositories/cart_repository.dart';
import 'package:impulsive_consumption/data/repositories/exceptions.dart';
import 'package:impulsive_consumption/data/services/checkout_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late CartRepository cart;
  late CheckoutService checkout;

  setUp(() async {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    await seedIfEmpty(db, rootBundle);
    cart = CartRepository(db);
    checkout = CheckoutService(db);
  });

  tearDown(() async => db.close());

  Future<CartItemWithProduct> addAndFetch(int productId, {int qty = 1}) async {
    await cart.add(productId, qty: qty);
    final items = await cart.watchDetailed().first;
    return items.singleWhere((e) => e.product.id == productId);
  }

  test('checkout is atomic across wallet/order/cart', () async {
    final item = await addAndFetch(1, qty: 2); // 2 × ¥4599.00
    final result = await checkout.checkout(items: [item]);

    expect(result.payableCents, 459900 * 2);

    // 钱包扣款 + 流水两条（初始+消费）
    final wallet = await (db.select(db.wallets)).getSingle();
    expect(wallet.balanceCents, 1000000 - 459900 * 2);
    final txs = await db.select(db.walletTransactions).get();
    expect(txs, hasLength(2));

    // 订单与明细快照
    final order =
        await (db.select(db.orders)..where((t) => t.id.equals(result.orderId)))
            .getSingle();
    expect(order.orderNo, startsWith('IC'));
    expect(order.status, OrderStatus.pendingShip);
    expect(order.paidAt, isNotNull);
    final items = await (db.select(db.orderItems)
          ..where((t) => t.orderId.equals(result.orderId)))
        .get();
    expect(items.single.unitPriceSnapshotCents, 459900);
    expect(items.single.quantity, 2);

    // 已购购物车项被清除
    expect(await db.select(db.cartItems).get(), isEmpty);
  });

  test('insufficient balance rolls back everything', () async {
    // 先花光余额：直接把钱包清零
    await (db.update(db.wallets)..where((t) => t.id.equals(1)))
        .write(const WalletsCompanion(balanceCents: Value(0)));

    final item = await addAndFetch(3, qty: 1);
    await expectLater(
      checkout.checkout(items: [item]),
      throwsA(isA<InsufficientBalanceException>()),
    );

    // 回滚断言：无订单、无流水、购物车保留
    expect(await db.select(db.orders).get(), isEmpty);
    expect(await db.select(db.walletTransactions).get(), hasLength(1));
    expect(await db.select(db.cartItems).get(), hasLength(1));
  });

  test('coupon discount applies and coupon gets consumed', () async {
    // 满300减30 → 用 ¥899 的智能手表(id=9)验证门槛内优惠
    final item = await addAndFetch(9, qty: 1);
    expect(item.product.priceCents, greaterThanOrEqualTo(30000));
    final coupons = await db.select(db.coupons).get();
    final c300 = coupons.singleWhere((c) => c.titleKey == 'couponOff30Over300');

    final result = await checkout.checkout(items: [item], couponId: c300.id);

    expect(result.discountCents, 3000);
    expect(
      result.payableCents,
      item.product.priceCents * item.item.quantity - result.discountCents,
    );

    final used = await (db.select(db.coupons)
          ..where((t) => t.id.equals(c300.id)))
        .getSingle();
    expect(used.status, CouponStatus.used);
  });

  test('below-threshold coupon rejected without side effects', () async {
    final item = await addAndFetch(16, qty: 1); // GaN 充电器 ¥129，低于满减门槛
    final coupons = await db.select(db.coupons).get();
    final c1000 =
        coupons.singleWhere((c) => c.titleKey == 'couponOff120Over1000');

    await expectLater(
      checkout.checkout(items: [item], couponId: c1000.id),
      throwsA(isA<CouponNotApplicableException>()),
    );
    expect(await db.select(db.orders).get(), isEmpty);
    final w = await db.select(db.wallets).getSingle();
    expect(w.balanceCents, 1000000);
  });

  test('unselected cart items survive checkout', () async {
    await cart.add(1, qty: 1);
    await cart.add(2, qty: 1);
    final rows = await db.select(db.cartItems).get();
    await cart.toggleSelect(rows[0].id, false); // 只留第2件勾选

    final items = await cart.watchDetailed().first;
    final result = await checkout.checkout(items: items);

    final remain = await db.select(db.cartItems).get();
    expect(remain, hasLength(1));
    expect(remain.single.productId, 1);
    expect(result.payableCents, 359900);
  });
}
