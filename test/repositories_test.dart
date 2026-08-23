import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/data/database/database.dart';
import 'package:impulsive_consumption/data/database/seed_loader.dart';
import 'package:impulsive_consumption/data/database/tables.dart';
import 'package:impulsive_consumption/data/repositories/cart_repository.dart';
import 'package:impulsive_consumption/data/repositories/checkin_repository.dart';
import 'package:impulsive_consumption/data/repositories/coupon_repository.dart';
import 'package:impulsive_consumption/data/repositories/exceptions.dart';
import 'package:impulsive_consumption/data/repositories/wallet_repository.dart';
import 'package:impulsive_consumption/data/repositories/wishlist_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late WalletRepository wallet;
  late CartRepository cart;

  setUp(() async {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    await seedIfEmpty(db, rootBundle);
    wallet = WalletRepository(db);
    cart = CartRepository(db);
  });

  tearDown(() async => db.close());

  group('CartRepository', () {
    test('add merges quantities and clamps to stock', () async {
      await cart.add(1, qty: 2);
      await cart.add(1, qty: 3);
      final p1 = await (db.select(db.products)..where((t) => t.id.equals(1)))
          .getSingle();

      var items = await cart.watchDetailed().first;
      expect(items.single.item.quantity, 5);

      // 超库存钳制
      await cart.add(1, qty: p1.stock);
      items = await cart.watchDetailed().first;
      expect(items.single.item.quantity, p1.stock);
    });

    test('setQuantity removes on zero and clamps high values', () async {
      await cart.add(2, qty: 1);
      final row = await db.select(db.cartItems).getSingle();
      await cart.setQuantity(row.id, 999); // 钳制到库存
      var after = await db.select(db.cartItems).getSingle();
      expect(after.quantity, lessThanOrEqualTo(1000));

      await cart.setQuantity(row.id, 0);
      expect(await db.select(db.cartItems).get(), isEmpty);
    });

    test('selected total only counts selected lines', () async {
      await cart.add(1, qty: 1); // ¥4599.00
      await cart.add(2, qty: 1); // ¥3599.00
      final rows = await db.select(db.cartItems).get();
      await cart.toggleSelect(rows[0].id, false);

      final total = await cart.selectedTotalCents();
      expect(total, 359900);
    });

    test('clear removes everything', () async {
      await cart.add(1);
      await cart.add(2);
      await cart.clear();
      expect(await db.select(db.cartItems).get(), isEmpty);
    });
  });

  group('WalletRepository', () {
    test('recharge credits balance and writes transaction', () async {
      await wallet.recharge(amountCents: 50000, ref: 'r1');
      final w = await wallet.account();
      expect(w.balanceCents, 1050000);
      expect(w.totalRechargeCents, 1050000);

      final tx = await wallet.watchTransactions().first;
      expect(tx.first.type, TxType.recharge);
      expect(tx.first.balanceAfterCents, 1050000);
    });

    test('spend throws when insufficient without side effects', () async {
      final before = await wallet.account();
      expect(
        () => wallet.spend(amountCents: before.balanceCents + 100),
        throwsA(isA<InsufficientBalanceException>()),
      );
      final after = await wallet.account();
      expect(after.balanceCents, before.balanceCents);
      expect(await db.select(db.walletTransactions).get(), hasLength(1));
    });

    test('spend deducts and records negative amount', () async {
      await wallet.spend(amountCents: 30000, ref: 'order-1');
      final w = await wallet.account();
      expect(w.balanceCents, 970000);
      expect(w.totalSpentCents, 30000);
      final tx = (await wallet.watchTransactions().first).first;
      expect(tx.amountCents, -30000);
    });
  });

  group('CouponRepository', () {
    test('discountFor respects threshold and caps at total', () async {
      final coupons = await db.select(db.coupons).get();
      final over300 =
          coupons.singleWhere((c) => c.titleKey == 'couponOff30Over300');
      expect(CouponRepository.discountFor(over300, 29999), 0);
      expect(CouponRepository.discountFor(over300, 30000), 3000);

      final rate = coupons.singleWhere((c) => c.titleKey == 'coupon95');
      expect(CouponRepository.discountFor(rate, 20000), 1000);
    });

    test('bestFor picks the biggest saving among usable coupons', () async {
      final all = await db.select(db.coupons).get();
      final best = CouponRepository.bestFor(all, 120000, DateTime.now());
      // 满1000减120 = 12000 > 满300减30 = 3000 > 95折 = 6000
      expect(best!.titleKey, 'couponOff120Over1000');
    });
  });

  group('WishlistRepository', () {
    test('toggle adds then removes', () async {
      final repo = WishlistRepository(db);
      expect(await repo.toggle(5), isTrue);
      expect(await repo.contains(5), isTrue);
      expect(await repo.toggle(5), isFalse);
      expect(await repo.contains(5), isFalse);
    });
  });

  group('CheckinRepository', () {
    test('streak accumulates across consecutive days with cycle rewards',
        () async {
      final repo = CheckinRepository(db, wallet);

      // 手工插入昨天连击到第7天的记录
      final now = DateTime.now();
      final yesterday = CheckinRepository.dateKey(now.subtract(const Duration(days: 1)));
      await db.into(db.checkins).insert(
            CheckinsCompanion.insert(dateKey: yesterday, rewardCents: 500, streak: 7),
          );

      final reward = await repo.checkIn();
      expect(reward, CheckinRepository.rewardFor(8)); // 第8天 → 回落到第1天档位 100
      expect(reward, 100);
    });

    test('broken streak resets to day1 reward', () async {
      final repo = CheckinRepository(db, wallet);
      final now = DateTime.now();
      final longAgo = CheckinRepository.dateKey(now.subtract(const Duration(days: 3)));
      await db.into(db.checkins).insert(
            CheckinsCompanion.insert(dateKey: longAgo, rewardCents: 400, streak: 6),
          );
      final reward = await repo.checkIn();
      expect(reward, 100);
    });

    test('second checkin same day returns null and does not duplicate',
        () async {
      final repo = CheckinRepository(db, wallet);
      expect(await repo.checkIn(), isNotNull);
      expect(await repo.checkIn(), isNull);
      expect(await db.select(db.checkins).get(), hasLength(1));
      // 初始流水 + 签到奖励一条
      expect(await db.select(db.walletTransactions).get(), hasLength(2));
    });
  });
}
