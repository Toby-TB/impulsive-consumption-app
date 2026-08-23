import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/repositories/product_repository.dart';

/// 首页金刚区/分类页共用。
final categoriesProvider = StreamProvider(
  (ref) => ref.watch(productRepositoryProvider).watchCategories(),
);

/// 秒杀横滑。
final flashSaleProvider = StreamProvider(
  (ref) => ref.watch(productRepositoryProvider).watchFlashSale(),
);

/// 猜你喜欢（按销量）。
final guessYouLikeProvider = StreamProvider(
  (ref) => ref.watch(productRepositoryProvider).watchAll(),
);

/// 分类页商品。
final categoryProductsProvider = StreamProvider.family(
  (ref, int categoryId) =>
      ref.watch(productRepositoryProvider).watchByCategory(categoryId),
);

/// 详情页商品。
final productByIdProvider = StreamProvider.autoDispose.family(
  (ref, int productId) =>
      ref.watch(productRepositoryProvider).watchById(productId),
);

/// 购物车角标数量。
final cartCountProvider = StreamProvider<int>(
  (ref) => ref.watch(cartRepositoryProvider).watchCount(),
);

/// 心愿单 id 集。
final wishlistIdsProvider = StreamProvider<Set<int>>(
  (ref) => ref.watch(wishlistRepositoryProvider).watchIds(),
);

/// 搜索状态。
class SearchState {
  final String query;
  final ProductSortMode sort;

  const SearchState({this.query = '', this.sort = ProductSortMode.best});

  SearchState copyWith({String? query, ProductSortMode? sort}) =>
      SearchState(query: query ?? this.query, sort: sort ?? this.sort);
}

class SearchController extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  void setQuery(String q) => state = state.copyWith(query: q);

  void setSort(ProductSortMode s) => state = state.copyWith(sort: s);
}

final searchControllerProvider =
    NotifierProvider<SearchController, SearchState>(SearchController.new);

final searchResultsProvider = StreamProvider(
  (ref) {
    final s = ref.watch(searchControllerProvider);
    return ref.watch(productRepositoryProvider).search(s.query, sort: s.sort);
  },
);
