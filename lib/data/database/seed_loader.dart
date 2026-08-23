import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show AssetBundle;

import '../../core/utils/localized_text.dart';
import 'database.dart';

const kInitialBalanceCents = 1000000; // ¥10,000
const _kProductsAsset = 'assets/data/products.json';

/// 库为空时灌入种子数据（幂等，可重复调用）。
Future<void> seedIfEmpty(AppDatabase db, AssetBundle bundle) async {
  final catCount = await db.categories.select().get();
  if (catCount.isEmpty) {
    final raw = await bundle.loadString(_kProductsAsset);
    await _seedCatalog(db, jsonDecode(raw) as Map<String, dynamic>);
  }

  final wallet = await db.select(db.wallets).getSingleOrNull();
  if (wallet == null) {
    final now = DateTime.now();
    await db.into(db.wallets).insertOnConflictUpdate(
          WalletsCompanion.insert(
            id: const Value(1),
            balanceCents: kInitialBalanceCents,
            totalRechargeCents: kInitialBalanceCents,
            totalSpentCents: 0,
          ),
        );
    await db.into(db.walletTransactions).insert(
          WalletTransactionsCompanion.insert(
            type: TxType.recharge,
            amountCents: kInitialBalanceCents,
            balanceAfterCents: kInitialBalanceCents,
            refText: const Value('initial'),
            createdAt: now,
          ),
        );
  }

  final coupons = await db.select(db.coupons).get();
  if (coupons.isEmpty) {
    final expires = DateTime.now().add(const Duration(days: 30));
    for (final c in [
      (key: 'couponOff30Over300', isRate: false, value: 3000, min: 30000),
      (key: 'coupon95', isRate: true, value: 5, min: 10000),
      (key: 'couponOff120Over1000', isRate: false, value: 12000, min: 100000),
    ]) {
      await db.into(db.coupons).insert(
            CouponsCompanion.insert(
              titleKey: c.key,
              isRate: c.isRate,
              valueInt: c.value,
              minSpendCents: c.min,
              expiresAt: expires,
              status: CouponStatus.available,
            ),
          );
    }
  }
}

Future<void> _seedCatalog(AppDatabase db, Map<String, dynamic> data) async {
  await db.batch((batch) {
    for (final c in data['categories'] as List<dynamic>) {
      final j = c as Map<String, dynamic>;
      batch.insert(
        db.categories,
        CategoriesCompanion.insert(
          id: Value(j['id'] as int),
          slug: j['slug'] as String,
          name: LocalizedText.fromJsonString(jsonEncode(j['name'])),
          emoji: j['emoji'] as String,
          sortOrder: j['sortOrder'] as int,
        ),
      );
    }

    for (final p in data['products'] as List<dynamic>) {
      final j = p as Map<String, dynamic>;
      batch.insert(
        db.products,
        ProductsCompanion.insert(
          id: Value(j['id'] as int),
          categoryId: j['categoryId'] as int,
        brand: LocalizedText.fromJsonString(jsonEncode(j['brand'])),
        name: LocalizedText.fromJsonString(jsonEncode(j['name'])),
        subtitle: LocalizedText.fromJsonString(jsonEncode(j['subtitle'])),
        description: LocalizedText.fromJsonString(jsonEncode(j['description'])),
        image: j['image'] as String? ??
            'assets/images/products/p${(j['id'] as int).toString().padLeft(3, '0')}.jpg',
        priceCents: j['priceCents'] as int,
        originalPriceCents: j['originalPriceCents'] as int,
        stock: j['stock'] as int,
        sales: j['sales'] as int,
        rating: (j['rating'] as num).toDouble(),
        tags: StringList((j['tags'] as List<dynamic>).cast<String>()),
        flashSale: Value(j['flashSale'] as bool? ?? false),
      ),
    );
    }
  });
}
