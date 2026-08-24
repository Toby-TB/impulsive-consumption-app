import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/data/database/database.dart';
import 'package:impulsive_consumption/data/database/seed_loader.dart';
import 'package:impulsive_consumption/data/repositories/address_repository.dart';
import 'package:impulsive_consumption/data/repositories/cart_repository.dart';
import 'package:impulsive_consumption/data/repositories/exceptions.dart';
import 'package:impulsive_consumption/data/repositories/order_repository.dart';
import 'package:impulsive_consumption/data/services/checkout_service.dart';
import 'package:impulsive_consumption/data/services/gamification_service.dart';
import 'package:impulsive_consumption/data/repositories/wallet_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late AddressRepository addresses;
  late GamificationService game;
  late WalletRepository wallet;

  setUp(() async {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    await seedIfEmpty(db, rootBundle);
    addresses = AddressRepository(db);
    game = GamificationService(db, wallet = WalletRepository(db));
  });

  tearDown(() async => db.close());

  group('GamificationMath', () {
    test('levelFor thresholds', () {
      expect(GamificationMath.levelFor(0), 1);
      expect(GamificationMath.levelFor(99), 1);
      expect(GamificationMath.levelFor(100), 2);
      expect(GamificationMath.levelFor(299), 2);
      expect(GamificationMath.levelFor(6000), 10);
      expect(GamificationMath.levelFor(7600), 11); // 6000+1600
    });

    test('levelRange', () {
      expect(GamificationMath.levelRange(0), (0, 100));
      expect(GamificationMath.levelRange(150), (100, 300));
      expect(GamificationMath.levelRange(5999), (4600, 6000));
      expect(GamificationMath.levelRange(6000), (6000, null));
      expect(GamificationMath.levelRange(7600), (7600, 9200));
    });

    test('titleFor', () {
      expect(GamificationMath.titleFor(0), 'titleRestrained');
      expect(GamificationMath.titleFor(60), 'titlePotential');
      expect(GamificationMath.titleFor(2500), 'titleGod');
    });
  });

  group('GamificationService.onOrderPaid', () {
    test('xp/impulse accumulate and first_order unlocks with reward',
        () async {
      // 先真实下单（服务内部按订单数/累计消费评估）
      final cart = CartRepository(db);
      await cart.add(1, qty: 1); // ¥4599
      final items = await cart.watchDetailed().first;
      await CheckoutService(db).checkout(items: items);

      final result = await game.onOrderPaid(
        payableCents: 459900,
        itemCount: 1,
      );

      expect(result.xpGained, 4599);
      expect(result.leveledUp, isTrue); // 4599xp → Lv3
      expect(result.unlocked.map((a) => a.key), contains('first_order'));
      expect(result.unlocked.map((a) => a.key), contains('spend_1k'));

      // 成就奖励入账：余额 = 1000000 - 消费 + 解锁奖励 + 升级奖励
      final rewardSum =
          result.unlocked.fold<int>(0, (s, a) => s + a.rewardCents) +
              result.levelUpRewardCents;
      final w = await wallet.account();
      expect(w.balanceCents, 1000000 - 459900 + rewardSum);

      final keys = await game.unlockedKeys();
      expect(keys, containsAll(['first_order', 'spend_1k']));

      // 重复结算不重复解锁
      await cart.add(2, qty: 1);
      final items2 = await cart.watchDetailed().first;
      await CheckoutService(db).checkout(items: items2);
      final again = await game.onOrderPaid(payableCents: 359900, itemCount: 1);
      expect(again.unlocked.map((a) => a.key), isNot(contains('first_order')));
    });

    test('big_spender requires single order >= ¥5000', () async {
      final cart = CartRepository(db);
      await cart.add(13, qty: 1); // ¥1699
      var items = await cart.watchDetailed().first;
      await CheckoutService(db).checkout(items: items);
      final small = await game.onOrderPaid(payableCents: 169900, itemCount: 1);
      expect(small.unlocked.map((a) => a.key), isNot(contains('big_spender')));

      await cart.add(1, qty: 1); // ¥4599 → 单笔 169900+459900? 单笔=本单 payable
      items = await cart.watchDetailed().first;
      await CheckoutService(db).checkout(items: items);
      final big = await game.onOrderPaid(payableCents: 600000, itemCount: 1);
      expect(big.unlocked.map((a) => a.key), contains('big_spender'));
    });

    test('streak achievements via onCheckin', () async {
      final r3 = await game.onCheckin(streak: 3);
      expect(r3.unlocked.map((a) => a.key), contains('streak_3'));
      expect(r3.xpGained, 20);

      final r7 = await game.onCheckin(streak: 7);
      expect(r7.unlocked.map((a) => a.key), contains('streak_7'));
    });

    test('cart/wishlist activity achievements', () async {
      final r = await game.onActivity(cartCount: 12, wishlistCount: 6);
      expect(r.unlocked.map((a) => a.key),
          containsAll(['cart_10', 'wishlist_5']));
    });
  });

  group('AddressRepository', () {
    // 注意：种子数据已含一条默认地址「冲冲」
    test('upsert with isDefault switches default', () async {
      expect((await addresses.defaultAddress())!.name, '冲冲');

      final idB = await addresses.upsert(
        name: 'B', phone: '2', region: 'R', detail: 'D', isDefault: true,
      );
      expect((await addresses.defaultAddress())!.id, idB);

      final idC = await addresses.upsert(
        name: 'C', phone: '3', region: 'R', detail: 'D',
      );
      expect((await addresses.defaultAddress())!.id, idB);

      await addresses.setDefault(idC);
      expect((await addresses.defaultAddress())!.id, idC);
    });

    test('removing default reassigns another', () async {
      final idB = await addresses.upsert(
        name: 'B', phone: '2', region: 'R', detail: 'D', isDefault: true,
      );
      expect((await addresses.defaultAddress())!.name, 'B');

      await addresses.remove(idB);
      final def = await addresses.defaultAddress();
      expect(def, isNotNull);
      expect(def!.name, isNot('B'));
    });
  });

  group('CheckoutService payment methods', () {
    late CartRepository cart;

    setUp(() {
      cart = CartRepository(db);
    });

    Future<AddressesData> addAddr() async {
      await addresses.upsert(
        name: '冲冲', phone: '138****8888', region: '广东 深圳', detail: '幸福小区 888',
      );
      return (await addresses.defaultAddress())!;
    }

    test('cod does not deduct at order time', () async {
      final addr = await addAddr();
      await cart.add(2, qty: 1); // ¥3599
      final items = await cart.watchDetailed().first;

      final result = await CheckoutService(db).checkout(items: items, address: addr, method: PaymentMethod.cod);

      final w = await wallet.account();
      expect(w.balanceCents, 1000000); // 未扣款
      final order = await (db.select(db.orders)
            ..where((t) => t.id.equals(result.orderId)))
          .getSingle();
      expect(order.settled, isFalse);
      expect(order.paymentMethod, PaymentMethod.cod);
      expect(order.receiverName, '冲冲');
      expect(order.receiverAddress, contains('幸福小区'));
    });

    test('cod settles on completion (allows negative balance)', () async {
      // 先把余额花到低于应付
      await wallet.spend(amountCents: 999000, ref: 'drain'); // 剩 ¥10
      final addr = await addAddr();
      await cart.add(2, qty: 1); // ¥3599
      final items = await cart.watchDetailed().first;
      final result = await CheckoutService(db).checkout(items: items, address: addr, method: PaymentMethod.cod);

      final repo = OrderRepositoryForTest(db);
      final paidAt =
          (await (db.select(db.orders)..where((t) => t.id.equals(result.orderId)))
              .getSingle())
          .paidAt!;
      await repo.advanceStatuses(paidAt.add(const Duration(seconds: 400)));

      final order = await (db.select(db.orders)..where((t) => t.id.equals(result.orderId)))
          .getSingle();
      expect(order.settled, isTrue);
      final w = await wallet.account();
      expect(w.balanceCents, 1000 - 359900); // 允许负余额（模拟赊账）
    });

    test('installment3 charges ceil(payable/3)', () async {
      final addr = await addAddr();
      await cart.add(1, qty: 1); // ¥4599 → 首期 ¥1533
      final items = await cart.watchDetailed().first;

      final result = await CheckoutService(db).checkout(items: items, address: addr, method: PaymentMethod.installment3);

      expect(result.firstInstallmentCents, (459900 / 3).ceil()); // 153300
      final w = await wallet.account();
      expect(w.balanceCents, 1000000 - 153300);
      final order = await (db.select(db.orders)
            ..where((t) => t.id.equals(result.orderId)))
          .getSingle();
      expect(order.installmentsPaid, 1);
      expect(order.settled, isTrue);
    });

    test('installment requires balance for first installment only', () async {
      await wallet.spend(amountCents: 900000, ref: 'drain'); // 剩 ¥1000
      final addr = await addAddr();
      await cart.add(1, qty: 1); // ¥4599，首期 ¥1533 > ¥1000
      final items = await cart.watchDetailed().first;

      await expectLater(
        CheckoutService(db).checkout(items: items, address: addr, method: PaymentMethod.installment3),
        throwsA(isA<InsufficientBalanceException>()),
      );
    });
  });
  group('Coins & Gacha', () {
    test('addCoins/spendCoins/exchange round trip', () async {
      // 种子初始 2000 金币
      expect(await game.watchCoins().first, 2000);
      expect(await game.addCoins(1500, reason: 'test'), 3500);
      expect(await game.spendCoins(500), isTrue);
      expect(await game.watchCoins().first, 3000);

      final got = await game.exchangeCoinsToBalance(1000);
      expect(got, 1000); // ¥10
      expect(await game.watchCoins().first, 2000);
      expect(await game.exchangeCoinsToBalance(350), isNull); // 非百倍数
    });

    test('openGacha deducts cost, applies prize, tracks pity', () async {
      await game.addCoins(12000, reason: 'seed');
      final before = await game.watchCoins().first;

      var sawSrOrAbove = false;
      for (var i = 1; i <= 10; i++) {
        final prize = await game.openGacha();
        expect(prize.amount, greaterThan(0));
        if (prize.rarity == GachaRarity.sr ||
            prize.rarity == GachaRarity.ssr) {
          sawSrOrAbove = true;
        }
        final pity = await game.gachaPityCount();
        expect(pity, i % 10);
      }
      expect(sawSrOrAbove, isTrue); // 10 抽内保底触发

      final after = await game.watchCoins().first;
      // 10 次扣 5000 + 奖励返还 > 0
      expect(after, greaterThan(before - 5000));
    });

    test('openGacha throws when coins insufficient', () async {
      await game.spendCoins(2000); // 清空种子金币
      await expectLater(
        game.openGacha(),
        throwsA(isA<InsufficientCoinsException>()),
      );
    });

    test('order paid grants coins', () async {
      final r = await game.onOrderPaid(payableCents: 200000, itemCount: 1);
      expect(r.coinsGained, 200000 ~/ 1000 + 10);
      expect(await game.watchCoins().first, 2000 + r.coinsGained);
    });
  });
}

class OrderRepositoryForTest {
  final AppDatabase db;
  OrderRepositoryForTest(this.db);

  Future<void> advanceStatuses(DateTime now) =>
      OrderRepository(db).advanceStatuses(now);
}
