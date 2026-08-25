import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:impulsive_consumption/data/database/database.dart';
import 'package:impulsive_consumption/data/database/seed_loader.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite3;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tmp;

  setUp(() => tmp = Directory.systemTemp.createTempSync('ic_migration'));
  tearDown(() => tmp.deleteSync(recursive: true));

  /// 用裸 SQL 构造一个 schema v1 的老库（无 v2/v3 表与列）。
  void createLegacyV1Database(String path) {
    final db = sqlite3.sqlite3.open(path);
    db.execute('PRAGMA user_version = 1');
    // v1 核心表（精简但结构对齐旧版）
    db.execute('CREATE TABLE categories (id INTEGER NOT NULL PRIMARY KEY, '
        'slug TEXT NOT NULL, name TEXT NOT NULL, emoji TEXT NOT NULL, '
        'sort_order INTEGER NOT NULL)');
    db.execute('CREATE TABLE products (id INTEGER NOT NULL PRIMARY KEY, '
        'category_id INTEGER NOT NULL, brand TEXT NOT NULL, name TEXT NOT NULL, '
        'subtitle TEXT NOT NULL, description TEXT NOT NULL, image TEXT NOT NULL, '
        'price_cents INTEGER NOT NULL, original_price_cents INTEGER NOT NULL, '
        'stock INTEGER NOT NULL, sales INTEGER NOT NULL, rating REAL NOT NULL, '
        'tags TEXT NOT NULL, flash_sale INTEGER NOT NULL DEFAULT 0)');
    db.execute('CREATE TABLE cart_items (id INTEGER PRIMARY KEY '
        'AUTOINCREMENT, product_id INTEGER NOT NULL UNIQUE, '
        'quantity INTEGER NOT NULL, selected INTEGER NOT NULL DEFAULT 1)');
    db.execute('CREATE TABLE wallets (id INTEGER NOT NULL PRIMARY KEY, '
        'balance_cents INTEGER NOT NULL, total_recharge_cents INTEGER NOT NULL, '
        'total_spent_cents INTEGER NOT NULL)');
    db.execute('CREATE TABLE wallet_transactions (id INTEGER PRIMARY KEY '
        'AUTOINCREMENT, type INTEGER NOT NULL, amount_cents INTEGER NOT NULL, '
        'balance_after_cents INTEGER NOT NULL, ref_text TEXT, '
        'created_at INTEGER NOT NULL)');
    // v1 形态的 orders：没有任何 v2 新列
    db.execute('CREATE TABLE orders (id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'order_no TEXT NOT NULL UNIQUE, status INTEGER NOT NULL, '
        'total_amount_cents INTEGER NOT NULL, discount_cents INTEGER NOT NULL, '
        'payable_cents INTEGER NOT NULL, coupon_id INTEGER, '
        'created_at INTEGER NOT NULL, paid_at INTEGER)');
    db.execute('CREATE TABLE order_items (id INTEGER PRIMARY KEY '
        'AUTOINCREMENT, order_id INTEGER NOT NULL, product_id INTEGER NOT NULL, '
        'quantity INTEGER NOT NULL, unit_price_snapshot_cents INTEGER NOT NULL)');
    db.execute('CREATE TABLE coupons (id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'title_key TEXT NOT NULL, is_rate INTEGER NOT NULL, '
        'value_int INTEGER NOT NULL, min_spend_cents INTEGER NOT NULL, '
        'expires_at INTEGER NOT NULL, status INTEGER NOT NULL)');
    db.execute('CREATE TABLE wishlist_items (id INTEGER PRIMARY KEY '
        'AUTOINCREMENT, product_id INTEGER NOT NULL UNIQUE, '
        'created_at INTEGER NOT NULL)');
    db.execute('CREATE TABLE checkins (id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'date_key TEXT NOT NULL UNIQUE, reward_cents INTEGER NOT NULL, '
        'streak INTEGER NOT NULL)');
    // 老数据：一条订单 + 钱包
    db.execute("INSERT INTO wallets VALUES (1, 1000000, 1000000, 0)");
    db.execute("INSERT INTO orders (order_no, status, total_amount_cents, "
        "discount_cents, payable_cents, created_at, paid_at) VALUES "
        "('ICLEGACY1', 3, 100000, 0, 100000, 1755900000000, 1755900000000)");
    db.close();
  }

    List<String> orderColumns(sqlite3.Database raw) {
    final rs = raw.select('PRAGMA table_info(orders)');
    return [for (final r in rs) r['name'] as String];
  }

  test('legacy v1 database upgrades to v3 without error', () async {
    final path = p.join(tmp.path, 'legacy.sqlite');
    createLegacyV1Database(path);

    final db = AppDatabase.forTesting(
      NativeDatabase(
        File(path),
        setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    addTearDown(() async => db.close());

    // 打开即触发迁移；此前版本会抛 no such table: gamification_state
    final wallet = await (db.select(db.wallets).getSingle());
    expect(wallet.balanceCents, 1000000); // 老数据保留

    // 应用启动流程：迁移后 seedIfEmpty 会补齐缺失种子（地址等）
    await seedIfEmpty(db, rootBundle);
    expect(await db.select(db.addresses).get(), isNotEmpty);
    final game = await (db.select(db.gamificationState)).getSingle();
    expect(game.coins, 2000); // v3 列 + 种子金币
    expect(game.gachaPity, 0);

    // v2 订单新列存在且老订单有默认值
    final cols = orderColumns(
      sqlite3.sqlite3.open(path),
    );
    expect(cols, containsAll(['payment_method', 'receiver_name', 'settled',
        'installments_paid', 'remark']));
    final legacy = await (db.select(db.orders)).getSingle();
    expect(legacy.orderNo, 'ICLEGACY1');
    expect(legacy.settled, isTrue);

    // 成就表已建
    expect(await db.select(db.achievements).get(), isEmpty);
  });

  test('fresh v3 database seeds and works', () async {
    final path = p.join(tmp.path, 'fresh.sqlite');
    final db = AppDatabase.forTesting(
      NativeDatabase(
        File(path),
        setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    addTearDown(() async => db.close());
    await seedIfEmpty(db, rootBundle);
    expect((await db.select(db.gamificationState).getSingle()).coins, 2000);
  });
}
