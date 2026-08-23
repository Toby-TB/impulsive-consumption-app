import 'package:drift/drift.dart';

import '../../core/utils/localized_text.dart';
import '../database/database.dart';

enum ProductSortMode { best, sales, priceAsc, priceDesc }

/// 列表卡片使用的商品行。
typedef ProductRow = Product;

class ProductRepository {
  final AppDatabase _db;

  ProductRepository(this._db);

  Stream<List<Product>> watchAll({int? limit}) {
    final q = _db.select(_db.products)
      ..orderBy([
        (t) => OrderingTerm.desc(t.sales),
      ]);
    if (limit != null) q.limit(limit);
    return q.watch();
  }

  Stream<List<Product>> watchFlashSale() {
    return (_db.select(_db.products)
          ..where((t) => t.flashSale.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.sales)]))
        .watch();
  }

  Stream<List<Product>> watchByCategory(int categoryId) {
    return (_db.select(_db.products)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.desc(t.sales)]))
        .watch();
  }

  Stream<Product?> watchById(int id) {
    return (_db.select(_db.products)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<Product?> byId(int id) {
    return (_db.select(_db.products)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// 搜索覆盖三语名称/副标题/品牌与标签（存储为 JSON 文本，天然跨语言匹配）。
  Stream<List<Product>> search(
    String query, {
    ProductSortMode sort = ProductSortMode.best,
  }) {
    final q = query.trim();
    final sel = _db.select(_db.products);
    if (q.isNotEmpty) {
      final like = '%$q%';
      sel.where(
        (t) =>
            t.name.like(like) |
            t.subtitle.like(like) |
            t.brand.like(like) |
            t.tags.like(like),
      );
    }
    sel.orderBy([
      switch (sort) {
        ProductSortMode.best => (t) => OrderingTerm.desc(t.rating),
        ProductSortMode.sales => (t) => OrderingTerm.desc(t.sales),
        ProductSortMode.priceAsc => (t) => OrderingTerm.asc(t.priceCents),
        ProductSortMode.priceDesc => (t) => OrderingTerm.desc(t.priceCents),
      },
      (t) => OrderingTerm.desc(t.sales),
    ]);
    return sel.watch();
  }

  Stream<List<Category>> watchCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  LocalizedText displayName(Product p, AppLanguage lang) =>
      p.name.of(lang) == '' ? p.name : p.name;
}
