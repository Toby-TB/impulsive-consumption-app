import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/localized_text.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/coupon_repository.dart';
import '../../../data/repositories/exceptions.dart';
import 'checkout_providers.dart';
import 'widgets/insufficient_dialog.dart';
import 'widgets/payment_success_overlay.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _couponInited = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = currentLang(context);
    final theme = Theme.of(context);
    final items = ref.watch(selectedItemsProvider).value ?? const [];
    final total =
        items.fold<int>(0, (sum, e) => sum + e.lineTotalCents);

    // 首次构建时默认带出最优券
    if (!_couponInited && items.isNotEmpty) {
      _couponInited = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) initCouponSelection(ref, total);
      });
    }

    final couponId = ref.watch(selectedCouponProvider);
    final coupons = ref.watch(availableCouponsProvider).value ?? const [];
    final discount = couponId == null
        ? 0
        : CouponRepository.discountFor(
            coupons.firstWhere(
              (c) => c.id == couponId,
              orElse: () => coupons.first,
            ),
            total,
          );
    final payable = total - discount;

    return Scaffold(
      appBar: AppBar(title: Text(l.checkoutTitle)),
      body: items.isEmpty
          ? Center(child: Text(l.cartEmptyTitle))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _AddressCard(),
                const SizedBox(height: 10),
                _ItemsCard(items: items, lang: lang),
                const SizedBox(height: 10),
                _CouponCard(
                  total: total,
                  discount: discount,
                  couponId: couponId,
                  onTap: () => _openCouponSheet(total),
                ),
                const SizedBox(height: 10),
                _PriceBreakdownCard(
                  total: total,
                  discount: discount,
                  payable: payable,
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(
              top: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: items.isEmpty
              ? const SizedBox(height: 44)
              : Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${l.payable}:',
                            style: const TextStyle(fontSize: 12)),
                        MoneyText(payable,
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => _pay(payable, couponId),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(140, 48),
                      ),
                      child: Text(l.payNow),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _pay(int payable, int? couponId) async {
    final l = context.l10n;
    final items = ref.read(selectedItemsProvider).value ?? const [];
    if (items.isEmpty) return;

    // 余额预检（真实校验在事务内）
    final wallet = await ref.read(walletRepositoryProvider).account();
    if (wallet.balanceCents < payable) {
      if (!mounted) return;
      await showInsufficientBalanceDialog(context, ref,
          missingCents: payable - wallet.balanceCents);
      return;
    }

    try {
      final result = await ref
          .read(checkoutServiceProvider)
          .checkout(items: items, couponId: couponId);

      if (!mounted) return;
      showPaymentSuccess(context, onFinished: () {
        if (!mounted) return;
        context.pushReplacement('/order/${result.orderId}');
      });
    } on InsufficientBalanceException catch (e) {
      if (!mounted) return;
      await showInsufficientBalanceDialog(context, ref, missingCents: e.missingCents);
    } on CouponNotApplicableException {
      if (!mounted) return;
      ref.read(selectedCouponProvider.notifier).state = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couponUnavailable)),
      );
    }
  }

  void _openCouponSheet(int total) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const _CouponSheet(),
      // 传入当前合计供门槛判断
    );
  }
}

class _AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${l.recipientLabel}: ${l.recipientName}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      Text(l.addressPhone,
                          style: TextStyle(
                              fontSize: 12, color: theme.hintColor)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(l.addressDetail,
                      style:
                          TextStyle(fontSize: 12, color: theme.hintColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final List items;
  final AppLanguage lang;

  const _ItemsCard({required this.items, required this.lang});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            for (final e in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(e.product.image,
                          width: 52, height: 52, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        e.product.name.of(lang),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    MoneyText(e.product.priceCents,
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
    );
  }
}

class _CouponCard extends ConsumerWidget {
  final int total;
  final int discount;
  final int? couponId;
  final VoidCallback onTap;

  const _CouponCard({
    required this.total,
    required this.discount,
    required this.couponId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final coupons = ref.watch(availableCouponsProvider).value ?? const [];
    final theme = Theme.of(context);

    String title;
    if (couponId == null) {
      title = l.noCoupon;
    } else {
      final c = coupons.where((c) => c.id == couponId).toList();
      title = c.isEmpty ? l.noCoupon : _couponTitle(context, c.first);
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.local_offer_outlined,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(l.coupon, style: const TextStyle(fontSize: 13)),
              const Spacer(),
              Text(
                discount > 0
                    ? l.savedAmount(
                        formatMoney(discount,
                            cur: ref.watch(regionProvider),
                            locale:
                                Localizations.localeOf(context).toString()))
                    : title,
                style: TextStyle(
                  fontSize: 13,
                  color: discount > 0 ? const Color(0xFFE02020) : theme.hintColor,
                ),
              ),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

String _couponTitle(BuildContext context, dynamic coupon) {
  final l = context.l10n;
  return switch (coupon.titleKey as String) {
    'couponOff30Over300' => l.couponOff30Over300,
    'couponOff120Over1000' => l.couponOff120Over1000,
    'coupon95' => l.coupon95,
    _ => l.couponNewcomer,
  };
}

class _CouponSheet extends ConsumerWidget {
  const _CouponSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final coupons = ref.watch(availableCouponsProvider).value ?? const [];
    final items = ref.watch(selectedItemsProvider).value ?? const [];
    final total = items.fold<int>(0, (s, e) => s + e.lineTotalCents);
    final selected = ref.watch(selectedCouponProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.couponAvailable,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // 不使用优惠券
            _CouponTile(
              title: l.noCoupon,
              subtitle: '',
              selected: selected == null,
              enabled: true,
              onTap: () => _pick(context, ref, null),
            ),
            for (final c in coupons) ...[
              const SizedBox(height: 8),
              Builder(builder: (context) {
                final usable = CouponRepository.isUsable(c, DateTime.now()) &&
                    total >= c.minSpendCents;
                return _CouponTile(
                  title: _couponTitle(context, c),
                  subtitle: c.minSpendCents > 0
                      ? l.couponThreshold(formatMoney(
                          c.minSpendCents,
                          cur: ref.watch(regionProvider),
                          locale:
                              Localizations.localeOf(context).toString()))
                      : '',
                  selected: selected == c.id,
                  enabled: usable,
                  onTap: usable ? () => _pick(context, ref, c.id) : null,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  void _pick(BuildContext context, WidgetRef ref, int? id) {
    ref.read(selectedCouponProvider.notifier).state = id;
    Navigator.of(context).pop();
  }
}

class _CouponTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;

  const _CouponTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: enabled ? 1 : .45,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    if (subtitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(subtitle,
                            style: TextStyle(
                                fontSize: 11, color: theme.hintColor)),
                      ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle,
                    color: theme.colorScheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceBreakdownCard extends ConsumerWidget {
  final int total;
  final int discount;
  final int payable;

  const _PriceBreakdownCard({
    required this.total,
    required this.discount,
    required this.payable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);

    Widget row(String label, int cents,
        {bool bold = false, Color? color}) {
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
            MoneyText(cents,
                style: TextStyle(fontSize: bold ? 17 : 13), color: color),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            row(l.itemsTotal, total),
            row(l.discount, -discount,
                color: const Color(0xFFE02020)),
            const Divider(),
            row(l.payable, payable, bold: true),
          ],
        ),
      ),
    );
  }
}
