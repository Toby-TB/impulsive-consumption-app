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
          // 顺序至关重要：先建 v2 新表，再加 v3 新列。
          // （曾因先 ALTER 后 CREATE 导致老库升级报 no such table）
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
          if (from < 3) {
            await _addColumnIfMissing(m, gamificationState,
                gamificationState.coins);
            await _addColumnIfMissing(m, gamificationState,
                gamificationState.gachaPity);
          }
        },
      );

  /// 防御性加列：列已存在时跳过（应对任何中间态数据库）。
  Future<void> _addColumnIfMissing(
    Migrator m,
    TableInfo table,
    Column column,
  ) async {
    final info = await customSelect(
      'PRAGMA table_info(${table.actualTableName})',
    ).get();
    final exists = info.any((row) => row.data['name'] == column.name);
    if (!exists) {
      await m.addColumn(table, column as GeneratedColumn);
    }
  }
}

QueryExecutor openConnection() => driftDatabase(
      name: 'impulsive_consumption',
      // Web 端必须提供 wasm 资源（相对路径基于 index.html 的 base-href 解析）
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
      // 闭包参数类型由上下文推断，无需导入 sqlite3 的具体类型
      native: DriftNativeOptions(
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
