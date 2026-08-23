import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/core/utils/localized_text.dart';
import 'package:impulsive_consumption/data/database/database.dart';
import 'package:impulsive_consumption/data/database/seed_loader.dart';
import 'package:impulsive_consumption/data/database/tables.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async => db.close());

  Future<void> seed() => seedIfEmpty(db, rootBundle);

  test('seedIfEmpty inserts full catalog, wallet and coupons', () async {
    await seed();

    final products = await db.select(db.products).get();
    expect(products.length, greaterThanOrEqualTo(140));
    expect(products.first.image, startsWith('assets/images/products/'));

    final categories = await db.select(db.categories).get();
    expect(categories.length, 12);

    final wallet = await db.select(db.wallets).getSingle();
    expect(wallet.balanceCents, 1000000);
    expect(wallet.totalRechargeCents, 1000000);

    final tx = await db.select(db.walletTransactions).get();
    expect(tx, hasLength(1));
    expect(tx.single.amountCents, 1000000);

    final coupons = await db.select(db.coupons).get();
    expect(coupons, hasLength(3));
  });

  test('seedIfEmpty is idempotent', () async {
    await seed();
    await seed(); // 第二次不应重复插入

    final products = await db.select(db.products).get();
    expect(products, hasLength(greaterThanOrEqualTo(140)));
    expect(await db.select(db.categories).get(), hasLength(12));
    expect(await db.select(db.walletTransactions).get(), hasLength(1));
    expect(await db.select(db.coupons).get(), hasLength(3));
  });

  test('cart productId is unique', () async {
    await seed();
    await db.into(db.cartItems).insert(
          CartItemsCompanion.insert(productId: 1, quantity: 1),
        );
    expect(
      () => db.into(db.cartItems).insert(
            CartItemsCompanion.insert(productId: 1, quantity: 2),
          ),
      throwsA(anything),
    );
  });

  test('localized fields round-trip through converter', () async {
    await seed();
    final row = await (db.select(db.products)
          ..where((t) => t.id.equals(1)))
        .getSingle();
    expect(row.name.of(AppLanguage.en), contains('X5 Pro'));
    expect(row.name.of(AppLanguage.zhHans), contains('星尘'));
    expect(row.name.of(AppLanguage.zhHant), contains('星塵'));
    expect(row.tags.values.isNotEmpty, isTrue);
  });

  test('order cascade deletes items', () async {
    await seed();
    final order = await db.into(db.orders).insert(
          OrdersCompanion.insert(
            orderNo: 'TEST-1',
            status: OrderStatus.pendingShip,
            totalAmountCents: 1000,
            discountCents: 0,
            payableCents: 1000,
            createdAt: DateTime.now(),
          ),
        );
    await db.into(db.orderItems).insert(
          OrderItemsCompanion.insert(
            orderId: order,
            productId: 2,
            quantity: 1,
            unitPriceSnapshotCents: 1000,
          ),
        );
    await (db.delete(db.orders)..where((t) => t.id.equals(order))).go();
    final left = await (db.select(db.orderItems)
          ..where((t) => t.orderId.equals(order)))
        .get();
    expect(left, isEmpty);
  });

  test('nullable couponId query works', () async {
    await seed();
    final rows =
        await (db.select(db.orders)..where((t) => t.couponId.isNull())).get();
    expect(rows, isEmpty);
  });
}
