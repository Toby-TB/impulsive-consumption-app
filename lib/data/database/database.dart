import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/utils/localized_text.dart';
import 'tables.dart';

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

QueryExecutor openConnection() => driftDatabase(name: 'impulsive_consumption');
