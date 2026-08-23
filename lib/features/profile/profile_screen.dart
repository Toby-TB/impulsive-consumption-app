import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import '../../../data/repositories/checkin_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final balance = ref.watch(_balanceProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l.navProfile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 用户卡
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withValues(alpha: .15),
                    child: Text('冲动',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.recipientName,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => context.push('/wallet'),
                          child: Row(
                            children: [
                              Text('${l.balance}: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).hintColor)),
                              MoneyText(balance,
                                  style: const TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 签到卡
          const _CheckinCard(),
          const SizedBox(height: 12),

          // 菜单
          Card(
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.receipt_long_outlined,
                  title: l.ordersTitle,
                  onTap: () => context.go('/orders'),
                ),
                _divider(context),
                _MenuTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: l.walletTitle,
                  onTap: () => context.push('/wallet'),
                ),
                _divider(context),
                _MenuTile(
                  icon: Icons.favorite_border,
                  title: l.wishlistTitle,
                  onTap: () => context.push('/wishlist'),
                ),
                _divider(context),
                _MenuTile(
                  icon: Icons.settings_outlined,
                  title: l.settings,
                  onTap: () => context.push('/settings'),
                ),
                _divider(context),
                _MenuTile(
                  icon: Icons.info_outline,
                  title: l.about,
                  onTap: () => _showAbout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) =>
      Divider(height: 1, indent: 54, color: Theme.of(context).dividerColor);

  void _showAbout(BuildContext context) {
    final l = context.l10n;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.about),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l.appTitle} v1.0.0'),
            const SizedBox(height: 10),
            Text(l.aboutDisclaimer,
                style: const TextStyle(fontSize: 12, height: 1.5)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.confirm),
          ),
        ],
      ),
    );
  }
}

final _balanceProvider = StreamProvider(
  (ref) => ref.watch(walletRepositoryProvider).watchAccount().map(
        (w) => w?.balanceCents ?? 0,
      ),
);

class _CheckinCard extends ConsumerWidget {
  const _CheckinCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final state = ref.watch(_checkinStateProvider).value;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l.checkin,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (state != null && state.currentStreak > 0)
                  Text(l.streakDays(state.currentStreak),
                      style: TextStyle(
                          fontSize: 12, color: theme.colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 14),

            // 七日条
            Row(
              children: [
                for (var day = 1; day <= 7; day++)
                  Expanded(child: _DayCell(day: day, state: state)),
              ],
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (state?.checkedToday ?? false)
                    ? null
                    : () => _doCheckin(context, ref),
                child: Text(
                  (state?.checkedToday ?? false)
                      ? l.checkedToday
                      : '${l.checkinNow} +${formatMoney(state?.nextRewardCents ?? 100, cur: ref.watch(regionProvider), locale: Localizations.localeOf(context).toString())}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doCheckin(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final reward = await ref.read(checkinRepositoryProvider).checkIn();
    if (!context.mounted || reward == null) return;

    // 领取成功动画弹窗
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Theme.of(ctx).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.celebration,
                  size: 56, color: Color(0xFFFF9A44)),
              const SizedBox(height: 12),
              Text(l.txCheckin,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              MoneyText(reward, style: const TextStyle(fontSize: 28)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final CheckinState? state;

  const _DayCell({required this.day, this.state});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final streak = state?.currentStreak ?? 0;
    final reached = day <= streak && streak > 0;
    final isNext = day == streak + 1 && !(state?.checkedToday ?? false);

    return Column(
      children: [
        Text(l.checkinDay(day),
            style: TextStyle(
                fontSize: 9,
                color: reached || isNext
                    ? theme.colorScheme.primary
                    : theme.hintColor)),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: reached
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: .6),
            border: isNext
                ? Border.all(
                    width: 1.5, color: theme.colorScheme.primary)
                : null,
          ),
          child: reached
              ? const Icon(Icons.check, size: 15, color: Colors.white)
              : Center(
                  child: Text(
                    '+${CheckinRepository.rewardFor(day) ~/ 100}',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isNext ? theme.colorScheme.primary : theme.hintColor),
                  ),
                ),
        ),
      ],
    );
  }
}

final _checkinStateProvider = StreamProvider(
  (ref) => ref.watch(checkinRepositoryProvider).watchState(),
);

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
