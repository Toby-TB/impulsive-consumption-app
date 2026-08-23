import 'package:drift/drift.dart';

import '../database/database.dart';
import '../database/tables.dart';

/// 券 + 实际可优惠金额。
class CouponWithDiscount {
  final Coupon coupon;
  final int discountCents;

  const CouponWithDiscount({required this.coupon, required this.discountCents});
}

class CouponRepository {
  final AppDatabase _db;

  CouponRepository(this._db);

  Stream<List<Coupon>> watchAvailable() {
    return (_db.select(_db.coupons)
          ..where((t) => t.status.equals(CouponStatus.available.index)))
        .watch();
  }

  static bool isUsable(Coupon c, DateTime now) =>
      c.status == CouponStatus.available && !now.isAfter(c.expiresAt);

  static int discountFor(Coupon c, int totalCents) {
    if (totalCents < c.minSpendCents) return 0;
    final raw = c.isRate ? totalCents * c.valueInt ~/ 100 : c.valueInt;
    return raw.clamp(0, totalCents);
  }

  /// 在可用券中挑选优惠力度最大的一张。
  static Coupon? bestFor(List<Coupon> coupons, int totalCents, DateTime now) {
    Coupon? best;
    var bestDiscount = 0;
    for (final c in coupons) {
      if (!isUsable(c, now)) continue;
      final d = discountFor(c, totalCents);
      if (d > bestDiscount) {
        best = c;
        bestDiscount = d;
      }
    }
    return best;
  }

  Future<Coupon?> byId(int id) =>
      (_db.select(_db.coupons)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> markUsed(int id) async {
    await (_db.update(_db.coupons)..where((t) => t.id.equals(id)))
        .write(const CouponsCompanion(status: Value(CouponStatus.used)));
  }
}
