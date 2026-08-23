import 'package:drift/drift.dart';

import '../../core/utils/stream_utils.dart';
import '../database/database.dart';
import '../database/tables.dart';
import '../services/logistics_calculator.dart';
import 'cart_repository.dart';

/// 订单 + 明细（明细动态关联当前语言商品名）。
class OrderItemWithProduct {
  final OrderItem item;
  final Product? product; // 商品可能被下架（此处数据集固定，通常非空）

  const OrderItemWithProduct({required this.item, this.product});

  int get lineTotalCents =>
      item.quantity * item.unitPriceSnapshotCents;
}

class OrderWithItems {
  final Order order;
  final List<OrderItemWithProduct> items;

  const OrderWithItems({required this.order, required this.items});
}

class OrderRepository {
  final AppDatabase _db;

  OrderRepository(this._db);

  /// 组合三表流，构建完整订单视图。
  Stream<List<OrderWithItems>> watchOrders() {
    final orders$ = _db.select(_db.orders).watch();
    final items$ = _db.select(_db.orderItems).watch();
    final products$ = _db.select(_db.products).watch();

    return combineLatest3(orders$, items$, products$,
        (orders, items, products) {
      final productById = {for (final p in products) p.id: p};
      final byOrder = <int, List<OrderItemWithProduct>>{};
      for (final it in items) {
        (byOrder[it.orderId] ??= [])
            .add(OrderItemWithProduct(item: it, product: productById[it.productId]));
      }
      final list = [
        for (final o in orders)
          OrderWithItems(order: o, items: byOrder[o.id] ?? const []),
      ]..sort((a, b) => b.order.createdAt.compareTo(a.order.createdAt));
      return list;
    });
  }

  Future<OrderWithItems?> byId(int id) async {
    final order = await (_db.select(_db.orders)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (order == null) return null;
    final rows = await (_db.select(_db.orderItems).join([
      leftOuterJoin(
          _db.products, _db.products.id.equalsExp(_db.orderItems.productId)),
    ])
          ..where(_db.orderItems.orderId.equals(id)))
        .get();
    return OrderWithItems(
      order: order,
      items: rows
          .map((r) => OrderItemWithProduct(
                item: r.readTable(_db.orderItems),
                product: r.readTableOrNull(_db.products),
              ))
          .toList(),
    );
  }

  /// 按付款时间推进订单状态（与物流推演一致）。
  Future<void> advanceStatuses(DateTime now) async {
    final rows = await (_db.select(_db.orders)
          ..where((t) => t.status.isNotIn([OrderStatus.completed.index]))
          ..where((t) => t.paidAt.isNotNull()))
        .get();
    for (final o in rows) {
      final target = LogisticsCalculator.statusAt(o.paidAt!, now);
      if (target != o.status) {
        await (_db.update(_db.orders)..where((t) => t.id.equals(o.id)))
            .write(OrdersCompanion(status: Value(target)));
      }
    }
  }

  /// 再次购买：把订单内商品合并回购物车。
  Future<void> buyAgain(int orderId, CartRepository cart) async {
    final items = await (_db.select(_db.orderItems)
          ..where((t) => t.orderId.equals(orderId)))
        .get();
    for (final it in items) {
      await cart.add(it.productId, qty: it.quantity);
    }
  }
}
