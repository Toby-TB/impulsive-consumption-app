import 'package:drift/drift.dart';

import '../database/database.dart';
import '../database/tables.dart';

/// 购物车行 + 商品信息聚合。
class CartItemWithProduct {
  final CartItem item;
  final Product product;

  const CartItemWithProduct({required this.item, required this.product});

  int get lineTotalCents => item.quantity * product.priceCents;
}

class CartRepository {
  final AppDatabase _db;

  CartRepository(this._db);

  Stream<List<CartItemWithProduct>> watchDetailed() {
    final query = _db.select(_db.cartItems).join([
      innerJoin(_db.products, _db.products.id.equalsExp(_db.cartItems.productId)),
    ]);
    return query.watch().map((rows) => rows
        .map((r) => CartItemWithProduct(
              item: r.readTable(_db.cartItems),
              product: r.readTable(_db.products),
            ))
        .toList());
  }

  Stream<int> watchCount() => _db.cartItems.select().watch().map(
        (rows) => rows.fold<int>(0, (sum, r) => sum + r.quantity),
      );

  Future<int> selectedTotalCents() async {
    final all = await watchDetailed().first;
    return all
        .where((e) => e.item.selected)
        .fold<int>(0, (sum, e) => sum + e.lineTotalCents);
  }

  /// 加入购物车；已存在则数量累加，均按库存钳制。
  Future<void> add(int productId, {int qty = 1}) async {
    await _db.transaction(() async {
      final product = await (_db.select(_db.products)
            ..where((t) => t.id.equals(productId)))
          .getSingle();
      final existing = await (_db.select(_db.cartItems)
            ..where((t) => t.productId.equals(productId)))
          .getSingleOrNull();

      if (existing == null) {
        final quantity = qty.clamp(1, product.stock);
        await _db.into(_db.cartItems).insert(
              CartItemsCompanion.insert(productId: productId, quantity: quantity),
            );
      } else {
        final merged = (existing.quantity + qty).clamp(1, product.stock);
        await (_db.update(_db.cartItems)
              ..where((t) => t.id.equals(existing.id)))
            .write(CartItemsCompanion(quantity: Value(merged)));
      }
    });
  }

  Future<void> setQuantity(int itemId, int quantity) async {
    await _db.transaction(() async {
      final row = await (_db.select(_db.cartItems)
            ..where((t) => t.id.equals(itemId)))
          .getSingleOrNull();
      if (row == null) return;
      if (quantity <= 0) {
        await removeItem(itemId);
        return;
      }
      final product = await (_db.select(_db.products)
            ..where((t) => t.id.equals(row.productId)))
          .getSingle();
      final clamped = quantity.clamp(1, product.stock);
      await (_db.update(_db.cartItems)..where((t) => t.id.equals(itemId)))
          .write(CartItemsCompanion(quantity: Value(clamped)));
    });
  }

  Future<void> toggleSelect(int itemId, bool selected) async {
    await (_db.update(_db.cartItems)..where((t) => t.id.equals(itemId)))
        .write(CartItemsCompanion(selected: Value(selected)));
  }

  Future<void> selectAll(bool selected) async {
    await _db.update(_db.cartItems)
        .write(CartItemsCompanion(selected: Value(selected)));
  }

  Future<void> removeItem(int itemId) async {
    await (_db.delete(_db.cartItems)..where((t) => t.id.equals(itemId))).go();
  }

  Future<void> removeSelected() async {
    await (_db.delete(_db.cartItems)..where((t) => t.selected.equals(true))).go();
  }

  Future<void> clear() async {
    await _db.delete(_db.cartItems).go();
  }
}
