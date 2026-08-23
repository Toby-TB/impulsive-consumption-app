import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/checkin_repository.dart';
import '../../data/repositories/coupon_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/wallet_repository.dart';
import '../../data/repositories/wishlist_repository.dart';
import '../../data/services/checkout_service.dart';

/// 由 main() 注入已种子化的数据库实例。
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('override in main()');
});

final productRepositoryProvider =
    Provider((ref) => ProductRepository(ref.watch(appDatabaseProvider)));

final cartRepositoryProvider =
    Provider((ref) => CartRepository(ref.watch(appDatabaseProvider)));

final walletRepositoryProvider =
    Provider((ref) => WalletRepository(ref.watch(appDatabaseProvider)));

final couponRepositoryProvider =
    Provider((ref) => CouponRepository(ref.watch(appDatabaseProvider)));

final orderRepositoryProvider =
    Provider((ref) => OrderRepository(ref.watch(appDatabaseProvider)));

final wishlistRepositoryProvider =
    Provider((ref) => WishlistRepository(ref.watch(appDatabaseProvider)));

final checkinRepositoryProvider = Provider(
  (ref) => CheckinRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(walletRepositoryProvider),
  ),
);

final checkoutServiceProvider =
    Provider((ref) => CheckoutService(ref.watch(appDatabaseProvider)));
