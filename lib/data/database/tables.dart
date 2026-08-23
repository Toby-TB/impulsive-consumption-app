import 'package:drift/drift.dart';

import '../../core/utils/localized_text.dart';

class LocalizedTextConverter extends TypeConverter<LocalizedText, String> {
  const LocalizedTextConverter();

  @override
  LocalizedText fromSql(String fromDb) =>
      LocalizedText.fromJsonString(fromDb);

  @override
  String toSql(LocalizedText value) => value.toJsonString();
}

class StringListConverter extends TypeConverter<StringList, String> {
  const StringListConverter();

  @override
  StringList fromSql(String fromDb) => StringList.fromJsonString(fromDb);

  @override
  String toSql(StringList value) => value.toJsonString();
}

enum TxType { recharge, spend, refund, checkin }

enum OrderStatus { pendingShip, shipping, delivering, completed }

enum CouponStatus { available, used, expired }

class Categories extends Table {
  IntColumn get id => integer()();
  TextColumn get slug => text()();
  TextColumn get name => text().map(const LocalizedTextConverter())();
  TextColumn get emoji => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  IntColumn get id => integer()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get brand => text().map(const LocalizedTextConverter())();
  TextColumn get name => text().map(const LocalizedTextConverter())();
  TextColumn get subtitle => text().map(const LocalizedTextConverter())();
  TextColumn get description => text().map(const LocalizedTextConverter())();
  TextColumn get image => text()();
  IntColumn get priceCents => integer()();
  IntColumn get originalPriceCents => integer()();
  IntColumn get stock => integer()();
  IntColumn get sales => integer()();
  RealColumn get rating => real()();
  TextColumn get tags => text().map(const StringListConverter())();
  BoolColumn get flashSale => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class CartItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().unique().references(Products, #id)();
  IntColumn get quantity => integer()();
  BoolColumn get selected => boolean().withDefault(const Constant(true))();
}

class Wallets extends Table {
  IntColumn get id => integer()();
  IntColumn get balanceCents => integer()();
  IntColumn get totalRechargeCents => integer()();
  IntColumn get totalSpentCents => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class WalletTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<TxType>()();
  // 正数入账，负数出账
  IntColumn get amountCents => integer()();
  IntColumn get balanceAfterCents => integer()();
  TextColumn get refText => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderNo => text().unique()();
  IntColumn get status => intEnum<OrderStatus>()();
  IntColumn get totalAmountCents => integer()();
  IntColumn get discountCents => integer()();
  IntColumn get payableCents => integer()();
  IntColumn get couponId => integer()
      .nullable()
      .references(Coupons, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get paidAt => dateTime().nullable()();
}

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceSnapshotCents => integer()();
}

class Coupons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titleKey => text()();
  BoolColumn get isRate => boolean()();
  // isRate=false 时为固定减免金额（分）；isRate=true 时为折扣百分比（5 表示 95 折）
  IntColumn get valueInt => integer()();
  IntColumn get minSpendCents => integer()();
  DateTimeColumn get expiresAt => dateTime()();
  IntColumn get status => intEnum<CouponStatus>()();
}

class WishlistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().unique().references(Products, #id)();
  DateTimeColumn get createdAt => dateTime()();
}

class Checkins extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dateKey => text().unique()();
  IntColumn get rewardCents => integer()();
  IntColumn get streak => integer()();
}
