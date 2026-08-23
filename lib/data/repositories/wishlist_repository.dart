
import '../database/database.dart';

class WishlistRepository {
  final AppDatabase _db;

  WishlistRepository(this._db);

  Stream<Set<int>> watchIds() =>
      _db.select(_db.wishlistItems).watch().map(
            (rows) => rows.map((r) => r.productId).toSet(),
          );

  Future<bool> contains(int productId) async {
    final row = await (_db.select(_db.wishlistItems)
          ..where((t) => t.productId.equals(productId)))
        .getSingleOrNull();
    return row != null;
  }

  /// 返回切换后的状态：true=已收藏。
  Future<bool> toggle(int productId) async {
    final existing = await (_db.select(_db.wishlistItems)
          ..where((t) => t.productId.equals(productId)))
        .getSingleOrNull();
    if (existing != null) {
      await (_db.delete(_db.wishlistItems)
            ..where((t) => t.id.equals(existing.id)))
          .go();
      return false;
    }
    await _db.into(_db.wishlistItems).insert(
          WishlistItemsCompanion.insert(productId: productId, createdAt: DateTime.now()),
        );
    return true;
  }
}
