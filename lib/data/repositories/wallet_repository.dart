import 'package:drift/drift.dart';

import '../database/database.dart';
import 'exceptions.dart';

class WalletRepository {
  final AppDatabase _db;

  WalletRepository(this._db);

  Stream<Wallet?> watchAccount() => _db.select(_db.wallets).watchSingleOrNull();

  Future<Wallet> account() async {
    final w = await _db.select(_db.wallets).getSingleOrNull();
    if (w == null) {
      throw StateError('wallet not seeded');
    }
    return w;
  }

  Stream<List<WalletTransaction>> watchTransactions() =>
      (_db.select(_db.walletTransactions)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt),
                  (t) => OrderingTerm.desc(t.id)]))
          .watch();

  /// 入账（充值/签到/退款）。返回变动后余额。
  Future<int> credit({
    required TxType type,
    required int amountCents,
    String? ref,
  }) async {
    assert(amountCents > 0);
    return _db.transaction(() async {
      final wallet = await account();
      final after = wallet.balanceCents + amountCents;
      await (_db.update(_db.wallets)..where((t) => t.id.equals(wallet.id))).write(
        WalletsCompanion(
          balanceCents: Value(after),
          totalRechargeCents: switch (type) {
            TxType.recharge =>
              Value(wallet.totalRechargeCents + amountCents),
            _ => const Value.absent(),
          },
        ),
      );
      await _db.into(_db.walletTransactions).insert(
            WalletTransactionsCompanion.insert(
              type: type,
              amountCents: amountCents,
              balanceAfterCents: after,
              refText: Value(ref),
              createdAt: DateTime.now(),
            ),
          );
      return after;
    });
  }

  /// 充值。
  Future<int> recharge({required int amountCents, String? ref}) =>
      credit(type: TxType.recharge, amountCents: amountCents, ref: ref);

  /// 扣款。余额不足抛 [InsufficientBalanceException]，不产生任何副作用。
  Future<void> spend({required int amountCents, String? ref}) async {
    assert(amountCents > 0);
    await _db.transaction(() async {
      final wallet = await account();
      final after = wallet.balanceCents - amountCents;
      if (after < 0) {
        throw InsufficientBalanceException(-after);
      }
      await (_db.update(_db.wallets)..where((t) => t.id.equals(wallet.id))).write(
        WalletsCompanion(
          balanceCents: Value(after),
          totalSpentCents: Value(wallet.totalSpentCents + amountCents),
        ),
      );
      await _db.into(_db.walletTransactions).insert(
            WalletTransactionsCompanion.insert(
              type: TxType.spend,
              amountCents: -amountCents,
              balanceAfterCents: after,
              refText: Value(ref),
              createdAt: DateTime.now(),
            ),
          );
    });
  }
}
