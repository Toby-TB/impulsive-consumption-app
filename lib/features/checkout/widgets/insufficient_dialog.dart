import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';

/// 余额不足弹窗：展示缺口并引导充值。
Future<void> showInsufficientBalanceDialog(
  BuildContext context,
  WidgetRef ref, {
  required int missingCents,
}) async {
  final l = context.l10n;
  final balance =
      ref.watch(_balanceSnipProvider).value ?? 0;
  final region = ref.watch(regionProvider);
  final locale = Localizations.localeOf(context).toString();

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.account_balance_wallet_outlined, size: 40),
      title: Text(l.insufficientTitle),
      content: Text(l.insufficientMsg(
        formatMoney(balance, cur: region, locale: locale),
        formatMoney(missingCents, cur: region, locale: locale),
      )),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.push('/wallet');
          },
          child: Text(l.goRecharge),
        ),
      ],
    ),
  );
}

final _balanceSnipProvider = StreamProvider(
  (ref) => ref.watch(walletRepositoryProvider).watchAccount().map(
        (w) => w?.balanceCents ?? 0,
      ),
);
