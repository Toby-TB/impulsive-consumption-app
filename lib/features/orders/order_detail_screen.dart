import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../data/database/database.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import 'widgets/logistics_timeline.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 物流时间轴 5s 实时刷新
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() => _now = DateTime.now());
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
    final lang = currentLang(context);
    final theme = Theme.of(context);
    final order =
        ref.watch(_orderProvider(widget.orderId)).value;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final o = order.order;
    final paidAt = o.paidAt ?? o.createdAt;
    final region = ref.watch(regionProvider);
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(title: Text(l.navOrders)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // 物流卡
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(l.logistics,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('${l.orderNoLabel} ${o.orderNo}',
                          style: TextStyle(
                              fontSize: 11, color: theme.hintColor)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  LogisticsTimeline(paidAt: paidAt, now: _now),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 收货信息 + 支付方式
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined,
                          size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(l.addressTitle,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (o.receiverName.isEmpty)
                    Text('—',
                        style: TextStyle(
                            fontSize: 12, color: theme.hintColor))
                  else ...[
                    Text('${o.receiverName}  ${o.receiverPhone}',
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(o.receiverAddress,
                        style: TextStyle(
                            fontSize: 12, color: theme.hintColor)),
                  ],
                  if (o.remark != null && o.remark!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('${l.buyerMessage}: ${o.remark}',
                        style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: theme.hintColor)),
                  ],
                  const Divider(height: 18),
                  Row(
                    children: [
                      Text(
                        switch (o.paymentMethod) {
                          PaymentMethod.balance => l.payBalance,
                          PaymentMethod.cod => l.payCod,
                          PaymentMethod.installment3 => l.payInstallment,
                        },
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      if (o.paymentMethod == PaymentMethod.cod && !o.settled)
                        Text(l.codNote,
                            style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.primary))
                      else if (o.paymentMethod ==
                              PaymentMethod.installment3 &&
                          o.installmentsPaid < 3)
                        Text(
                          l.installmentProgress(o.installmentsPaid),
                          style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.primary),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 商品明细
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  for (final e in order.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                                e.product?.image ??
                                    'assets/images/products/p001.jpg',
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              e.product?.name.of(lang) ?? o.orderNo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 8),
                          MoneyText(e.item.unitPriceSnapshotCents,
                              style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 8),
                          Text('x${e.item.quantity}',
                              style: TextStyle(
                                  fontSize: 12, color: theme.hintColor)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 金额明细
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row(l.itemsTotal,
                      formatMoney(o.totalAmountCents, cur: region, locale: locale)),
                  if (o.discountCents > 0)
                    _row(l.discount,
                        '-${formatMoney(o.discountCents, cur: region, locale: locale)}',
                        color: const Color(0xFFE02020)),
                  _row(l.payable,
                      formatMoney(o.payableCents, cur: region, locale: locale),
                      bold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 再次购买
          FilledButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final router = GoRouter.of(context);
              await ref
                  .read(orderRepositoryProvider)
                  .buyAgain(o.id, ref.read(cartRepositoryProvider));
              messenger.showSnackBar(
                SnackBar(
                    content: Text(l.addedToCart),
                    duration: const Duration(milliseconds: 800)),
              );
              router.go('/cart');
            },
            child: Text(l.buyAgain),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false, Color? color}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: bold ? null : theme.hintColor,
                  fontWeight: bold ? FontWeight.bold : null)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 16 : 13,
                  fontWeight: bold ? FontWeight.bold : null,
                  color: color)),
        ],
      ),
    );
  }
}

final _orderProvider = StreamProvider.autoDispose.family(
  (ref, int orderId) async* {
    final repo = ref.watch(orderRepositoryProvider);
    // 订单详情：直接查询 + 随订单流刷新
    await for (final _ in repo.watchOrders()) {
      final o = await repo.byId(orderId);
      if (o != null) yield o;
    }
  },
);
