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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

QueryExecutor openConnection() => driftDatabase(
      name: 'impulsive_consumption',
      // 闭包参数类型由上下文推断，无需导入 sqlite3 的具体类型
      native: DriftNativeOptions(
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
