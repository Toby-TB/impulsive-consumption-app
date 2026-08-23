import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/coupon_repository.dart';

/// 结算页勾选商品流。
final selectedItemsProvider = StreamProvider<List<CartItemWithProduct>>(
  (ref) => ref.watch(cartRepositoryProvider).watchDetailed().map(
        (all) => all.where((e) => e.item.selected).toList(),
      ),
);

/// 可用券流。
final availableCouponsProvider = StreamProvider<List<Coupon>>(
  (ref) => ref.watch(couponRepositoryProvider).watchAvailable(),
);

/// 已选优惠券 id（null = 不使用）。
final selectedCouponProvider = StateProvider<int?>((ref) => null);

/// 打开结算页时的初始化：默认带出最优可用券。
void initCouponSelection(WidgetRef ref, int totalCents) {
  final coupons = ref.read(availableCouponsProvider).value ?? const [];
  final best = CouponRepository.bestFor(coupons, totalCents, DateTime.now());
  ref.read(selectedCouponProvider.notifier).state = best?.id;
}
