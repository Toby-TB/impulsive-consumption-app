import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/order_repository.dart';

/// 订单列表状态过滤。
enum OrderFilter { all, pendingShip, shipping, delivering, completed }

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  OrderFilter _filter = OrderFilter.all;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // 进入订单页时推进一次数据库状态，之后周期刷新物流
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderRepositoryProvider).advanceStatuses(DateTime.now());
    });
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      ref.read(orderRepositoryProvider).advanceStatuses(DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final orders = ref.watch(_ordersProvider).value ?? const [];

    final filtered = _filter == OrderFilter.all
        ? orders
        : orders
            .where((o) => o.order.status.name == _filter.name)
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l.ordersTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(
              children: [
                _FilterChip(
                  label: l.statusAll,
                  selected: _filter == OrderFilter.all,
                  onTap: () => setState(() => _filter = OrderFilter.all),
                ),
                _FilterChip(
                  label: l.orderStatusPendingShip,
                  selected: _filter == OrderFilter.pendingShip,
                  onTap: () =>
                      setState(() => _filter = OrderFilter.pendingShip),
                ),
                _FilterChip(
                  label: l.orderStatusShipping,
                  selected: _filter == OrderFilter.shipping,
                  onTap: () =>
                      setState(() => _filter = OrderFilter.shipping),
                ),
                _FilterChip(
                  label: l.orderStatusDelivering,
                  selected: _filter == OrderFilter.delivering,
                  onTap: () =>
                      setState(() => _filter = OrderFilter.delivering),
                ),
                _FilterChip(
                  label: l.orderStatusCompleted,
                  selected: _filter == OrderFilter.completed,
                  onTap: () =>
                      setState(() => _filter = OrderFilter.completed),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyOrders()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) =>
                        _OrderCard(order: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

final _ordersProvider = StreamProvider(
  (ref) => ref.watch(orderRepositoryProvider).watchOrders(),
);

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: .12)
                : Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: .5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long,
              size: 72, color: Theme.of(context).hintColor),
          const SizedBox(height: 12),
          Text(l.orderEmptyTitle,
              style: TextStyle(color: Theme.of(context).hintColor)),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/home'),
            child: Text(l.orderEmptyAction),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final OrderWithItems order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = currentLang(context);
    final theme = Theme.of(context);
    final o = order.order;

    return Card(
      child: InkWell(
        onTap: () => context.push('/order/${o.id}'),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 状态行
              Row(
                children: [
                  Text('${l.orderNoLabel} ${o.orderNo}',
                      style: TextStyle(
                          fontSize: 11, color: theme.hintColor)),
                  const Spacer(),
                  _StatusChip(status: o.status),
                ],
              ),
              const SizedBox(height: 8),

              // 商品预览（最多两行）
              for (final e in order.items.take(2))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                            e.product?.image ??
                                'assets/images/products/p001.jpg',
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.product?.name.of(lang) ?? o.orderNo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text('x${e.item.quantity}',
                          style: TextStyle(
                              fontSize: 11, color: theme.hintColor)),
                    ],
                  ),
                ),
              if (order.items.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '+${order.items.length - 2}',
                    style: TextStyle(
                        fontSize: 11, color: theme.hintColor),
                  ),
                ),

              const SizedBox(height: 8),
              Divider(height: 1, color: theme.dividerColor),
              const SizedBox(height: 8),

              // 金额与操作
              Row(
                children: [
                  Text(
                    '${l.payable}: ',
                    style: const TextStyle(fontSize: 12),
                  ),
                  MoneyText(o.payableCents,
                      style: const TextStyle(fontSize: 15)),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final router = GoRouter.of(context);
                      await ref
                          .read(orderRepositoryProvider)
                          .buyAgain(o.id, ref.read(cartRepositoryProvider));
                      messenger.showSnackBar(
                        SnackBar(
                            content: Text(l.addedToCart),
                            duration:
                                const Duration(milliseconds: 800)),
                      );
                      router.go('/cart');
                    },
                    child: Text(l.buyAgain),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final color = switch (status) {
      OrderStatus.pendingShip => const Color(0xFFFF9800),
      OrderStatus.shipping => const Color(0xFF2196F3),
      OrderStatus.delivering => const Color(0xFF9C27B0),
      OrderStatus.completed => const Color(0xFF4CAF50),
    };
    final label = switch (status) {
      OrderStatus.pendingShip => l.orderStatusPendingShip,
      OrderStatus.shipping => l.orderStatusShipping,
      OrderStatus.delivering => l.orderStatusDelivering,
      OrderStatus.completed => l.orderStatusCompleted,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
