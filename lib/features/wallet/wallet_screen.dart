import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/providers/preferences_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import '../../../data/database/database.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final account = ref.watch(_accountProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l.walletTitle)),
      body: account == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _BalanceCard(account: account),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => _showRechargeSheet(context, ref),
                  child: Text(l.recharge),
                ),
                const SizedBox(height: 20),
                Text(l.transactions,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const _TransactionList(),
              ],
            ),
    );
  }

  void _showRechargeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _RechargeSheet(),
    );
  }
}

final _accountProvider = StreamProvider(
  (ref) => ref.watch(walletRepositoryProvider).watchAccount(),
);

class _BalanceCard extends ConsumerWidget {
  final Wallet account;

  const _BalanceCard({required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF5F3C), Color(0xFFFF9A44)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.balance,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: .85), fontSize: 13)),
          const SizedBox(height: 6),
          MoneyText(
            account.balanceCents,
            style: const TextStyle(fontSize: 32, color: Colors.white),
            color: Colors.white,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Stat(label: l.totalRecharged, cents: account.totalRechargeCents),
              const SizedBox(width: 24),
              _Stat(label: l.totalSpent, cents: account.totalSpentCents),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends ConsumerWidget {
  final String label;
  final int cents;

  const _Stat({required this.label, required this.cents});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final region = ref.watch(regionProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(color: Colors.white.withValues(alpha: .75), fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          formatMoney(cents, cur: region, locale: locale),
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _RechargeSheet extends ConsumerStatefulWidget {
  const _RechargeSheet();

  @override
  ConsumerState<_RechargeSheet> createState() => _RechargeSheetState();
}

class _RechargeSheetState extends ConsumerState<_RechargeSheet> {
  final _customController = TextEditingController();
  int? _selectedCents;

  static const _presets = {
    FxCurrency.cny: [5000, 20000, 100000],
    FxCurrency.usd: [500, 2000, 10000],
    FxCurrency.hkd: [4000, 20000, 50000],
  };

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final region = ref.watch(regionProvider);
    final presets = _presets[region]!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.recharge,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final p in presets) ...[
                  Expanded(
                    child: _PresetCard(
                      cents: p,
                      selected: _selectedCents == p,
                      onTap: () {
                        setState(() {
                          _selectedCents = p;
                          _customController.clear();
                        });
                      },
                    ),
                  ),
                  if (p != presets.last) const SizedBox(width: 10),
                ],
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _customController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: '${l.customAmount} (${region.symbol})',
                prefixIcon: const Icon(Icons.edit_outlined, size: 18),
              ),
              onChanged: (v) {
                final amount = double.tryParse(v);
                setState(() {
                  _selectedCents =
                      amount == null ? null : parsePresetToBaseCents(amount, region);
                });
              },
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _selectedCents == null || _selectedCents! <= 0
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      final router = GoRouter.of(context);
                      final amount = _selectedCents!;
                      await ref
                          .read(walletRepositoryProvider)
                          .recharge(amountCents: amount, ref: 'recharge');
                      if (!mounted) return;
                      navigator.pop();
                      router.pop();
                      messenger.showSnackBar(
                        SnackBar(
                            content: Text(l.rechargeSuccess),
                            duration: const Duration(milliseconds: 900)),
                      );
                    },
              child: Text(l.recharge),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetCard extends ConsumerWidget {
  final int cents;
  final bool selected;
  final VoidCallback onTap;

  const _PresetCard({
    required this.cents,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = context.watchRegion(ref);
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: .12)
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: .5),
          border: Border.all(
            width: 1.5,
            color: selected ? theme.colorScheme.primary : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          formatMoney(cents, cur: region, locale: Localizations.localeOf(context).toString()),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? theme.colorScheme.primary : null,
          ),
        ),
      ),
    );
  }
}

class _TransactionList extends ConsumerWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final txs = ref.watch(_txProvider).value ?? const [];

    if (txs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(l.emptyResult,
              style: TextStyle(color: Theme.of(context).hintColor)),
        ),
      );
    }

    return Column(
      children: [
        for (final tx in txs)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .1),
                  child: Icon(
                    switch (tx.type) {
                      TxType.recharge => Icons.add_card,
                      TxType.spend => Icons.shopping_bag_outlined,
                      TxType.refund => Icons.replay,
                      TxType.checkin => Icons.verified_outlined,
                    },
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        switch (tx.type) {
                          TxType.recharge => l.txRecharge,
                          TxType.spend => l.txSpend,
                          TxType.refund => l.txSpend,
                          TxType.checkin => l.txCheckin,
                        },
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.txBalanceAfter(
                          formatMoney(
                            tx.balanceAfterCents,
                            cur: ref.watch(regionProvider),
                            locale: Localizations.localeOf(context).toString(),
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      (tx.amountCents > 0 ? '+' : '') +
                          formatMoney(tx.amountCents,
                              cur: ref.watch(regionProvider),
                              locale:
                                  Localizations.localeOf(context).toString()),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: tx.amountCents > 0
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE02020),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _fmtTime(tx.createdAt),
                      style: TextStyle(
                          fontSize: 10, color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _fmtTime(DateTime t) {
    final l = t.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')} '
        '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}

final _txProvider = StreamProvider(
  (ref) => ref.watch(walletRepositoryProvider).watchTransactions(),
);
