import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/utils/localized_text.dart';
import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Products,
    CartItems,
    Wallets,
    WalletTransactions,
    Orders,
    OrderItems,
    Coupons,
    WishlistItems,
    Checkins,
    Addresses,
    GamificationState,
    Achievements,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 3) {
            await m.addColumn(gamificationState, gamificationState.coins);
            await m.addColumn(gamificationState, gamificationState.gachaPity);
          }
          if (from < 2) {
            await m.createTable(addresses);
            await m.createTable(gamificationState);
            await m.createTable(achievements);
            await m.addColumn(orders, orders.paymentMethod);
            await m.addColumn(orders, orders.receiverName);
            await m.addColumn(orders, orders.receiverPhone);
            await m.addColumn(orders, orders.receiverAddress);
            await m.addColumn(orders, orders.remark);
            await m.addColumn(orders, orders.settled);
            await m.addColumn(orders, orders.installmentsPaid);
          }
        },
      );
}

QueryExecutor openConnection() => driftDatabase(
      name: 'impulsive_consumption',
      // 闭包参数类型由上下文推断，无需导入 sqlite3 的具体类型
      native: DriftNativeOptions(
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
