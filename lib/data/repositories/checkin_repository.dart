import 'package:drift/drift.dart';

import '../database/database.dart';
import '../database/tables.dart';
import 'wallet_repository.dart';

/// 签到页面状态。
class CheckinState {
  final bool checkedToday;
  final int currentStreak;
  final int nextRewardCents; // 已签=明日的奖励；未签=今日可领

  const CheckinState({
    required this.checkedToday,
    required this.currentStreak,
    required this.nextRewardCents,
  });
}

class CheckinRepository {
  final AppDatabase _db;
  final WalletRepository _wallet;

  CheckinRepository(this._db, this._wallet);

  static const kRewardTable = [100, 150, 200, 250, 300, 400, 500];

  /// day1..day7 循环；streak 从 1 开始。
  static int rewardFor(int streak) => kRewardTable[(streak - 1) % 7];

  static String dateKey(DateTime t) {
    final l = t.toLocal();
    return '${l.year.toString().padLeft(4, '0')}-'
        '${l.month.toString().padLeft(2, '0')}-'
        '${l.day.toString().padLeft(2, '0')}';
  }

  Stream<CheckinState> watchState() {
    return _db.select(_db.checkins).watch().map((rows) => _stateFrom(rows));
  }

  CheckinState _stateFrom(List<Checkin> rows) {
    if (rows.isEmpty) {
      return const CheckinState(
        checkedToday: false,
        currentStreak: 0,
        nextRewardCents: 100,
      );
    }
    final sorted = [...rows]..sort((a, b) => b.dateKey.compareTo(a.dateKey));
    final last = sorted.first;
    final now = DateTime.now();
    final todayKey = dateKey(now);
    final yesterdayKey = dateKey(now.subtract(const Duration(days: 1)));

    final checkedToday = last.dateKey == todayKey;
    final chainAlive = checkedToday || last.dateKey == yesterdayKey;
    if (!chainAlive) {
      // 断签：连击清零重新计
      return const CheckinState(
        checkedToday: false,
        currentStreak: 0,
        nextRewardCents: 100,
      );
    }
    final currentStreak = checkedToday ? last.streak : last.streak;
    return CheckinState(
      checkedToday: checkedToday,
      currentStreak: currentStreak,
      nextRewardCents: rewardFor(currentStreak + 1),
    );
  }

  /// 签到。已签过返回 null，否则返回本次奖励并计入钱包。
  Future<int?> checkIn() async {
    final now = DateTime.now();
    final key = dateKey(now);
    final existing = await (_db.select(_db.checkins)
          ..where((t) => t.dateKey.equals(key)))
        .getSingleOrNull();
    if (existing != null) return null;

    final rows = await _db.select(_db.checkins).get();
    final yesterday = dateKey(now.subtract(const Duration(days: 1)));
    var streak = 1;
    for (final r in rows) {
      if (r.dateKey == yesterday) {
        streak = r.streak + 1;
        break;
      }
    }
    final reward = rewardFor(streak);

    await _db.transaction(() async {
      await _db.into(_db.checkins).insert(
            CheckinsCompanion.insert(
              dateKey: key,
              rewardCents: reward,
              streak: streak,
            ),
          );
      await _wallet.credit(type: TxType.checkin, amountCents: reward, ref: key);
    });
    return reward;
  }
}
