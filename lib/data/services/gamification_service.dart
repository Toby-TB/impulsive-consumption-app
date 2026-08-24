import 'dart:math';

import 'package:drift/drift.dart';

import '../database/database.dart';
import '../repositories/wallet_repository.dart';

/// 成就定义。
class AchievementDef {
  final String key;
  final int rewardCents;
  final int xpReward;
  final bool Function(GameStats s) isMet;

  const AchievementDef({
    required this.key,
    required this.rewardCents,
    this.xpReward = 50,
    required this.isMet,
  });

  static final all = <AchievementDef>[
    AchievementDef(
      key: 'first_order',
      rewardCents: 500,
      xpReward: 50,
      isMet: (s) => s.orderCount >= 1,
    ),
    AchievementDef(
      key: 'orders_5',
      rewardCents: 800,
      xpReward: 100,
      isMet: (s) => s.orderCount >= 5,
    ),
    AchievementDef(
      key: 'spend_1k',
      rewardCents: 500,
      xpReward: 50,
      isMet: (s) => s.totalSpentCents >= 100000,
    ),
    AchievementDef(
      key: 'spend_10k',
      rewardCents: 2000,
      xpReward: 200,
      isMet: (s) => s.totalSpentCents >= 1000000,
    ),
    AchievementDef(
      key: 'big_spender',
      rewardCents: 1000,
      xpReward: 100,
      isMet: (s) => s.lastPayableCents >= 500000,
    ),
    AchievementDef(
      key: 'cart_10',
      rewardCents: 300,
      xpReward: 30,
      isMet: (s) => s.cartCount >= 10,
    ),
    AchievementDef(
      key: 'wishlist_5',
      rewardCents: 300,
      xpReward: 30,
      isMet: (s) => s.wishlistCount >= 5,
    ),
    AchievementDef(
      key: 'streak_3',
      rewardCents: 300,
      isMet: (s) => s.streak >= 3,
    ),
    AchievementDef(
      key: 'streak_7',
      rewardCents: 800,
      xpReward: 150,
      isMet: (s) => s.streak >= 7,
    ),
    AchievementDef(
      key: 'level_5',
      rewardCents: 1000,
      xpReward: 0,
      isMet: (s) => s.level >= 5,
    ),
  ];

  static AchievementDef? byKey(String key) {
    for (final a in all) {
      if (a.key == key) return a;
    }
    return null;
  }
}

/// 评估成就所需的统计快照（0 值表示该维度不参与本次评估）。
class GameStats {
  final int orderCount;
  final int totalSpentCents;
  final int lastPayableCents;
  final int cartCount;
  final int wishlistCount;
  final int streak;
  final int level;

  const GameStats({
    required this.orderCount,
    required this.totalSpentCents,
    required this.lastPayableCents,
    required this.cartCount,
    required this.wishlistCount,
    required this.streak,
    required this.level,
  });
}

enum GachaType { coins, credit, coupon }

enum GachaRarity { n, r, sr, ssr }

class GachaPrize {
  final GachaType type;
  final int amount;
  final GachaRarity rarity;
  final String key;

  const GachaPrize(this.type, this.amount, this.rarity, {required this.key});
}

class InsufficientCoinsException implements Exception {
  final int missing;
  const InsufficientCoinsException(this.missing);
  @override
  String toString() => 'InsufficientCoinsException(missing: \$missing)';
}

/// 一次游戏化事件的结果，用于支付成功动画展示。
class GamificationResult {
  final int xpGained;
  final int oldLevel;
  final int newLevel;
  final int impulseGained;
  final List<AchievementDef> unlocked;
  final int levelUpRewardCents;
  final int coinsGained;

  const GamificationResult({
    required this.xpGained,
    required this.oldLevel,
    required this.newLevel,
    required this.impulseGained,
    required this.unlocked,
    required this.levelUpRewardCents,
    this.coinsGained = 0,
  });

  bool get leveledUp => newLevel > oldLevel;
}

/// 等级阈值：Lv1..Lv10 之后每 +1600 XP 一级。
abstract final class GamificationMath {
  static const kThresholds = [
    0, 100, 300, 600, 1000, 1600, 2400, 3400, 4600, 6000,
  ];
  static const kPostStep = 1600;

  static int levelFor(int xp) {
    var level = 1;
    for (var i = 0; i < kThresholds.length; i++) {
      if (xp >= kThresholds[i]) level = i + 1;
    }
    final last = kThresholds.last;
    if (xp >= last) {
      level += (xp - last) ~/ kPostStep;
    }
    return level;
  }

  /// 当前等级起始 XP 与下一级目标 XP。
  static (int, int?) levelRange(int xp) {
    final level = levelFor(xp);
    if (level <= kThresholds.length) {
      final start = kThresholds[level - 1];
      final next = level < kThresholds.length ? kThresholds[level] : null;
      return (start, next);
    }
    final lastThreshold = kThresholds.last;
    final start =
        lastThreshold + (level - kThresholds.length) * kPostStep;
    return (start, start + kPostStep);
  }

  /// 冲动值称号。
  static const kImpulseTitles = [
    (0, 'titleRestrained'),
    (50, 'titlePotential'),
    (150, 'titleNoviceSplurger'),
    (300, 'titleSplurger'),
    (600, 'titleSilver'),
    (1000, 'titleGold'),
    (2000, 'titleGod'),
  ];

  static String titleFor(int impulsePoints) {
    var title = kImpulseTitles.first.$2;
    for (final (threshold, key) in kImpulseTitles) {
      if (impulsePoints >= threshold) title = key;
    }
    return title;
  }
}

/// 游戏化服务：XP/等级/冲动值/成就判定与奖励发放。
class GamificationService {
  final AppDatabase _db;
  final WalletRepository _wallet;

  GamificationService(this._db, this._wallet);

  static const _kCheckinXp = 20;
  static const _kLevelUpRewardBase = 500;

  Stream<GamificationStateData> watchState() =>
      (_db.select(_db.gamificationState)..where((t) => t.id.equals(1)))
          .watchSingle();

  Future<GamificationStateData> currentState() async =>
      (_db.select(_db.gamificationState)..where((t) => t.id.equals(1)))
          .getSingle();

  Stream<List<Achievement>> watchUnlocked() =>
      (_db.select(_db.achievements)
            ..orderBy([(t) => OrderingTerm.desc(t.unlockedAt)]))
          .watch();

  Future<Set<String>> unlockedKeys() async {
    final rows = await _db.select(_db.achievements).get();
    return rows.map((r) => r.key).toSet();
  }

  /// 下单支付后的游戏化结算（在 CheckoutService 事务提交后调用）。
  Future<GamificationResult> onOrderPaid({
    required int payableCents,
    required int itemCount,
  }) {
    return _apply(
      xpGain: payableCents ~/ 100, // 每 ¥1 = 1 XP
      impulseGain: payableCents ~/ 5000 + (itemCount >= 5 ? 5 : 0),
      coinsGain: payableCents ~/ 1000 + 10, // 消费返金币：每 ¥10 +1，保底 10
      stats: GameStats(
        orderCount: -1, // -1 = 内部查询
        totalSpentCents: -1,
        lastPayableCents: payableCents,
        cartCount: 0,
        wishlistCount: -1,
        streak: 0,
        level: 0,
      ),
    );
  }

  /// 签到后调用。
  Future<GamificationResult> onCheckin({required int streak}) {
    return _apply(
      xpGain: _kCheckinXp,
      impulseGain: 0,
      coinsGain: 30,
      stats: GameStats(
        orderCount: 0,
        totalSpentCents: 0,
        lastPayableCents: 0,
        cartCount: 0,
        wishlistCount: 0,
        streak: streak,
        level: 0,
      ),
    );
  }

  /// 加购/收藏变化后调用。
  Future<GamificationResult> onActivity({
    required int cartCount,
    required int wishlistCount,
  }) {
    return _apply(
      xpGain: 0,
      impulseGain: 0,
      stats: GameStats(
        orderCount: 0,
        totalSpentCents: 0,
        lastPayableCents: 0,
        cartCount: cartCount,
        wishlistCount: wishlistCount,
        streak: 0,
        level: 0,
      ),
    );
  }

  // ---- 金币经济 ----

  Stream<int> watchCoins() =>
      watchState().map((s) => s.coins);

  Future<int> addCoins(int amount, {String? reason}) async {
    assert(amount > 0);
    final state = await currentState();
    final after = state.coins + amount;
    await (_db.update(_db.gamificationState)
          ..where((t) => t.id.equals(state.id)))
        .write(GamificationStateCompanion(coins: Value(after)));
    return after;
  }

  /// 余额不足返回 false。
  Future<bool> spendCoins(int amount) async {
    assert(amount > 0);
    return _db.transaction(() async {
      final state = await currentState();
      if (state.coins < amount) return false;
      await (_db.update(_db.gamificationState)
            ..where((t) => t.id.equals(state.id)))
          .write(GamificationStateCompanion(
        coins: Value(state.coins - amount),
      ));
      return true;
    });
  }

  static const kCoinsPerCny = 100; // 100 金币 = ¥1

  /// 金币兑换余额。返回兑换到的分数；金币不足返回 null。
  Future<int?> exchangeCoinsToBalance(int coins) async {
    if (coins <= 0 || coins % kCoinsPerCny != 0) return null;
    final ok = await spendCoins(coins);
    if (!ok) return null;
    final cny = coins ~/ kCoinsPerCny;
    await _wallet.credit(
      type: TxType.recharge,
      amountCents: cny * 100,
      ref: 'coin_exchange',
    );
    return cny * 100;
  }

  /// 连击奖励金币。
  Future<int> awardComboCoins(int comboCount) {
    return addCoins(comboCount * 10, reason: 'combo');
  }

  // ---- 开箱购 ----

  static const kGachaCost = 500;
  static const _kPityEvery = 10;

  /// 开箱：扣金币 → 按权重 roll → 保底 → 发奖。返回奖品类与数值。
  Future<GachaPrize> openGacha() async {
    final state = await currentState();
    if (state.coins < kGachaCost) {
      throw InsufficientCoinsException(kGachaCost - state.coins);
    }
    await spendCoins(kGachaCost);

    final pityCount = state.gachaPity + 1;
    final forceHigh = pityCount >= _kPityEvery;
    final prize = _roll(forceHigh: forceHigh);
    await _applyPrize(prize);
    await (_db.update(_db.gamificationState)
          ..where((t) => t.id.equals(1)))
        .write(GamificationStateCompanion(
      gachaPity: Value(pityCount >= _kPityEvery ? 0 : pityCount),
    ));
    return prize;
  }

  Future<int> gachaPityCount() async => (await currentState()).gachaPity;

  GachaPrize _roll({required bool forceHigh}) {
    final rng = Random();
    final roll = rng.nextDouble() * 100;
    if (forceHigh) {
      // 保底：SSR 红包 或 大额金币
      return rng.nextBool()
          ? const GachaPrize(GachaType.credit, 5000, GachaRarity.ssr,
              key: 'prizeCredit50')
          : const GachaPrize(GachaType.coins, 2000, GachaRarity.sr,
              key: 'prizeCoins2000');
    }
    if (roll < 30) {
      return const GachaPrize(GachaType.coins, 150, GachaRarity.n,
          key: 'prizeCoins150');
    } else if (roll < 55) {
      return const GachaPrize(GachaType.coins, 400, GachaRarity.r,
          key: 'prizeCoins400');
    } else if (roll < 75) {
      return const GachaPrize(GachaType.credit, 100, GachaRarity.r,
          key: 'prizeCredit1');
    } else if (roll < 92) {
      return const GachaPrize(GachaType.coupon, 1000, GachaRarity.sr,
          key: 'prizeCoupon');
    } else {
      return const GachaPrize(GachaType.credit, 2000, GachaRarity.sr,
          key: 'prizeCredit20');
    }
  }

  Future<void> _applyPrize(GachaPrize prize) async {
    switch (prize.type) {
      case GachaType.coins:
        await addCoins(prize.amount, reason: 'gacha');
      case GachaType.credit:
        await _wallet.credit(
          type: TxType.recharge,
          amountCents: prize.amount,
          ref: 'gacha',
        );
      case GachaType.coupon:
        await _db.into(_db.coupons).insert(
              CouponsCompanion.insert(
                titleKey: 'couponGacha',
                isRate: false,
                valueInt: prize.amount, // 满 ¥50 减 ¥10
                minSpendCents: 5000,
                expiresAt: DateTime.now().add(const Duration(days: 7)),
                status: CouponStatus.available,
              ),
            );
    }
  }

  /// 内部统计购物车/心愿单后评估活动类成就，返回新解锁列表。
  Future<List<AchievementDef>> evaluateActivity() async {
    final c = _db.cartItems.quantity.sum();
    final q = _db.selectOnly(_db.cartItems)..addColumns([c]);
    final cartCount = await q.map((r) => r.read(c) ?? 0).getSingle();
    final result = await onActivity(
      cartCount: cartCount,
      wishlistCount: await _countWishlist(),
    );
    return result.unlocked;
  }

  // ---- 内部 ----

  Future<int> _countOrders() async {
    final c = _db.orders.id.count();
    final q = _db.selectOnly(_db.orders)..addColumns([c]);
    return await q.map((r) => r.read(c) ?? 0).getSingle();
  }

  Future<int> _countWishlist() async {
    final c = _db.wishlistItems.id.count();
    final q = _db.selectOnly(_db.wishlistItems)..addColumns([c]);
    return await q.map((r) => r.read(c) ?? 0).getSingle();
  }

  Future<GamificationResult> _apply({
    required int xpGain,
    required int impulseGain,
    int coinsGain = 0,
    required GameStats stats,
  }) async {
    return _db.transaction(() async {
      final state = await currentState();
      final oldLevel = state.level;
      var xp = state.xp + xpGain;
      var level = GamificationMath.levelFor(xp);
      final impulse = state.impulsePoints + impulseGain;

      await (_db.update(_db.gamificationState)
            ..where((t) => t.id.equals(state.id)))
          .write(GamificationStateCompanion(
        xp: Value(xp),
        level: Value(level),
        impulsePoints: Value(impulse),
        coins: coinsGain > 0 ? Value(state.coins + coinsGain) : const Value.absent(),
      ));

      final unlocked = <AchievementDef>[];

      Future<void> evaluateAll() async {
        final effective = GameStats(
          orderCount: stats.orderCount < 0 ? await _countOrders() : stats.orderCount,
          totalSpentCents:
              stats.totalSpentCents < 0 ? (await _wallet.account()).totalSpentCents : stats.totalSpentCents,
          lastPayableCents: stats.lastPayableCents,
          cartCount: stats.cartCount,
          wishlistCount:
              stats.wishlistCount < 0 ? await _countWishlist() : stats.wishlistCount,
          streak: stats.streak,
          level: level,
        );
        final already = await unlockedKeys();
        for (final def in AchievementDef.all) {
          if (already.contains(def.key) ||
              unlocked.any((u) => u.key == def.key)) {
            continue;
          }
          if (!def.isMet(effective)) continue;
          await _db.into(_db.achievements).insert(
                AchievementsCompanion.insert(
                  key: def.key,
                  unlockedAt: DateTime.now(),
                  rewardCents: def.rewardCents,
                ),
              );
          await _wallet.credit(
            type: TxType.achievement,
            amountCents: def.rewardCents,
            ref: 'ach:${def.key}',
          );
          xp += def.xpReward;
          unlocked.add(def);
        }
      }

      // 第一轮成就评估
      await evaluateAll();

      // XP 增长可能升级 → 升级奖励 + 复评 level_5
      final newLevel = GamificationMath.levelFor(xp);
      var levelUpReward = 0;
      if (newLevel > level) {
        level = newLevel;
        levelUpReward = newLevel * _kLevelUpRewardBase;
        await _wallet.credit(
          type: TxType.achievement,
          amountCents: levelUpReward,
          ref: 'level_up:$newLevel',
        );
        await evaluateAll();
      }

      await (_db.update(_db.gamificationState)
            ..where((t) => t.id.equals(state.id)))
          .write(GamificationStateCompanion(
        xp: Value(xp),
        level: Value(level),
      ));

      return GamificationResult(
        xpGained: xpGain,
        oldLevel: oldLevel,
        newLevel: level,
        impulseGained: impulseGain,
        unlocked: unlocked,
        levelUpRewardCents: levelUpReward,
        coinsGained: coinsGain,
      );
    });
  }
}
