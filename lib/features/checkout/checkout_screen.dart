import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/localized_text.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';
import '../../../data/repositories/coupon_repository.dart';
import '../../../data/repositories/exceptions.dart';
import 'checkout_providers.dart';
import 'widgets/address_sheets.dart';
import '../../../core/juice/juice_fx.dart';
import 'widgets/insufficient_dialog.dart';
import 'widgets/payment_success_overlay.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _couponInited = false;
  bool _crit = false;
  AddressesData? _address;
  PaymentMethod _method = PaymentMethod.balance;
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final addr = await ref.read(addressRepositoryProvider).defaultAddress();
      if (mounted) setState(() => _address = addr);
    });
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = currentLang(context);
    final theme = Theme.of(context);
    final items = ref.watch(selectedItemsProvider).value ?? const [];
    final total = items.fold<int>(0, (sum, e) => sum + e.lineTotalCents);

    if (!_couponInited && items.isNotEmpty) {
      _couponInited = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        initCouponSelection(ref, total);
        // 暴击判定：25% 概率（有可用券时才有意义）
        final couponsNow = ref.read(availableCouponsProvider).value ?? const [];
        final hasUsable =
            couponsNow.any((c) => CouponRepository.isUsable(c, DateTime.now()));
        if (hasUsable && Random().nextDouble() < 0.25) {
          setState(() => _crit = true);
          JuiceFX.critFlash(context, label: l.critActive);
        }
      });
    }

    final couponId = ref.watch(selectedCouponProvider);
    final coupons = ref.watch(availableCouponsProvider).value ?? const [];
    final baseDiscount = couponId == null
        ? 0
        : CouponRepository.discountFor(
            coupons.firstWhere(
              (c) => c.id == couponId,
              orElse: () => coupons.first,
            ),
            total,
          );
    final discount = (_crit ? baseDiscount * 2 : baseDiscount).clamp(0, total);
    final payable = total - discount;
    final firstInstallment = (payable / 3).ceil();

    return Scaffold(
      appBar: AppBar(title: Text(l.checkoutTitle)),
      body: items.isEmpty
          ? Center(child: Text(l.cartEmptyTitle))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _AddressCard(
                  address: _address,
                  onTap: () async {
                    final picked = await showAddressPicker(context);
                    if (picked != null) {
                      setState(() => _address = picked);
                    } else {
                      // 可能刚新增了默认地址，刷新
                      final def = await ref
                          .read(addressRepositoryProvider)
                          .defaultAddress();
                      if (mounted) setState(() => _address = def);
                    }
                  },
                ),
                const SizedBox(height: 10),
                _ItemsCard(items: items, lang: lang),
                const SizedBox(height: 10),
                _CouponCard(
                  total: total,
                  discount: discount,
                  couponId: couponId,
                  crit: _crit,
                  onTap: () => _openCouponSheet(total),
                ),
                const SizedBox(height: 10),
                _PaymentMethodCard(
                  method: _method,
                  firstInstallment: firstInstallment,
                  onSelect: (m) => setState(() => _method = m),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: TextField(
                      controller: _remarkController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: l.remarkHint,
                        border: InputBorder.none,
                        icon: const Icon(Icons.sticky_note_2_outlined,
                            size: 18),
                      ),
                    ),
                  ),
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
            border: Border(top: BorderSide(color: theme.dividerColor)),
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

    // 地址校验
    if (_address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.addressRequired)),
      );
      final picked = await showAddressPicker(context);
      if (picked != null) setState(() => _address = picked);
      return;
    }

    // 资金预检（真实校验在事务内）
    final wallet = await ref.read(walletRepositoryProvider).account();
    final required = _method == PaymentMethod.installment3
        ? (payable / 3).ceil()
        : payable;
    if (_method != PaymentMethod.cod && wallet.balanceCents < required) {
      if (!mounted) return;
      await showInsufficientBalanceDialog(context, ref,
          missingCents: required - wallet.balanceCents);
      return;
    }

    try {
      final result = await ref.read(checkoutServiceProvider).checkout(
            items: items,
            couponId: couponId,
            address: _address,
            method: _method,
            critMultiplier: _crit ? 2 : 1,
            remark: _remarkController.text.trim().isEmpty
                ? null
                : _remarkController.text.trim(),
          );

      // 游戏化结算（COD 也给经验：先体验后付款）
      final celebrationData = await ref
          .read(gamificationServiceProvider)
          .onOrderPaid(
            payableCents: result.payableCents,
            itemCount: items.fold<int>(0, (s, e) => s + e.item.quantity),
          );

      if (!mounted) return;
      final region = ref.read(regionProvider);
      final locale = Localizations.localeOf(context).toString();
      showPaymentSuccess(
        context,
        celebration: PaymentCelebration(
          payableCents: result.payableCents,
          xpGained: celebrationData.xpGained,
          impulseGained: celebrationData.impulseGained,
          oldLevel: celebrationData.oldLevel,
          newLevel: celebrationData.newLevel,
          levelUpRewardCents: celebrationData.levelUpRewardCents,
          coinsGained: celebrationData.coinsGained,
          achievementKeys:
              celebrationData.unlocked.map((a) => a.key).toList(),
        ),
        region: region,
        locale: locale,
        localizeAchievement: (key) => achievementL10n(context, key),
        continueLabel: l.paymentContinue,
        onFinished: () {
          if (!mounted) return;
          context.pushReplacement('/order/${result.orderId}');
        },
      );
    } on InsufficientBalanceException catch (e) {
      if (!mounted) return;
      await showInsufficientBalanceDialog(context, ref,
          missingCents: e.missingCents);
    } on CouponNotApplicableException {
      if (!mounted) return;
      ref.read(selectedCouponProvider.notifier).state = null;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.couponUnavailable)));
    }
  }

  void _openCouponSheet(int total) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const _CouponSheet(),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressesData? address;
  final VoidCallback onTap;

  const _AddressCard({required this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final a = address;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined,
                  color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: a == null
                    ? Text(l.addressRequired,
                        style: TextStyle(
                            fontSize: 13, color: theme.hintColor))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('${a.name}  ${a.phone}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${a.region} ${a.detail}',
                              style: TextStyle(
                                  fontSize: 12, color: theme.hintColor)),
                        ],
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
  final bool crit;
  final VoidCallback onTap;

  const _CouponCard({
    required this.total,
    required this.discount,
    required this.couponId,
    required this.crit,
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
                    ? (couponId != null && crit
                        ? '\${l.critActive} \${l.savedAmount(formatMoney(discount, cur: ref.watch(regionProvider), locale: Localizations.localeOf(context).toString()))}'
                        : l.savedAmount(formatMoney(discount, cur: ref.watch(regionProvider), locale: Localizations.localeOf(context).toString())))
                    : title,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      discount > 0 ? const Color(0xFFE02020) : theme.hintColor,
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

class _PaymentMethodCard extends ConsumerWidget {
  final PaymentMethod method;
  final int firstInstallment;
  final ValueChanged<PaymentMethod> onSelect;

  const _PaymentMethodCard({
    required this.method,
    required this.firstInstallment,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final region = ref.watch(regionProvider);

    Widget row(PaymentMethod value, IconData icon, String title, String note) {
      final selected = method == value;
      return InkWell(
        onTap: () => onSelect(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500)),
                    if (note.isNotEmpty)
                      Text(note,
                          style: TextStyle(
                              fontSize: 11, color: theme.hintColor)),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 20,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.hintColor,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(l.paymentMethodLabel,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
            ),
            row(PaymentMethod.balance, Icons.account_balance_wallet_outlined,
                l.payBalance, ''),
            row(PaymentMethod.cod, Icons.local_shipping_outlined, l.payCod,
                l.payCodNote),
            row(
              PaymentMethod.installment3,
              Icons.calendar_month_outlined,
              l.payInstallment,
              l.payInstallmentNote(formatMoney(firstInstallment,
                  cur: region, locale: locale)),
            ),
          ],
        ),
      ),
    );
  }
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
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
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
                      ? l.couponThreshold(formatMoney(c.minSpendCents,
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
              color: selected ? theme.colorScheme.primary : theme.dividerColor,
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

    Widget row(String label, int cents, {bool bold = false, Color? color}) {
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
            row(l.discount, -discount, color: const Color(0xFFE02020)),
            const Divider(),
            row(l.payable, payable, bold: true),
          ],
        ),
      ),
    );
  }
}
