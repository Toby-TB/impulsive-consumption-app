import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';
import '../../../data/services/gamification_service.dart';

/// 成就墙：已解锁点亮，未解锁置灰。
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final unlocked = ref.watch(_unlockedProvider).value ?? const [];
    final unlockedKeys = unlocked.map((a) => a.key).toSet();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.achievementsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // 进度概览
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
            child: Row(
              children: [
                Text(
                  '${unlockedKeys.length} / ${AchievementDef.all.length}',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary),
                ),
                const Spacer(),
                Icon(Icons.emoji_events,
                    size: 16, color: Colors.amber.shade700),
              ],
            ),
          ),
          for (final def in AchievementDef.all)
            _AchievementTile(
              def: def,
              unlocked: unlockedKeys.contains(def.key),
              unlockedAt: unlocked
                  .where((a) => a.key == def.key)
                  .map((a) => a.unlockedAt)
                  .firstOrNull,
            ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _AchievementTile extends ConsumerWidget {
  final AchievementDef def;
  final bool unlocked;
  final DateTime? unlockedAt;

  const _AchievementTile({
    required this.def,
    required this.unlocked,
    this.unlockedAt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final title = achievementL10n(context, def.key);
    final desc = switch (def.key) {
      'first_order' => l.achFirstOrderDesc,
      'orders_5' => l.achOrders5Desc,
      'spend_1k' => l.achSpend1kDesc,
      'spend_10k' => l.achSpend10kDesc,
      'big_spender' => l.achBigSpenderDesc,
      'cart_10' => l.achCart10Desc,
      'wishlist_5' => l.achWishlist5Desc,
      'streak_3' => l.achStreak3Desc,
      'streak_7' => l.achStreak7Desc,
      _ => l.achLevel5Desc,
    };

    return Opacity(
      opacity: unlocked ? 1 : .5,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked
                  ? Colors.amber.shade700.withValues(alpha: .18)
                  : theme.colorScheme.surfaceContainerHighest,
            ),
            child: Icon(
              unlocked ? Icons.emoji_events : Icons.lock_outline,
              size: 22,
              color: unlocked ? Colors.amber.shade700 : theme.hintColor,
            ),
          ),
          title: Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: unlocked ? null : theme.hintColor)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(desc, style: const TextStyle(fontSize: 11)),
              const SizedBox(height: 3),
              Text(
                unlocked
                    ? '${l.rewardFormat(formatMoney(def.rewardCents, cur: ref.watch(regionProvider), locale: Localizations.localeOf(context).toString()))} · ${_fmt(unlockedAt)}'
                    : l.locked,
                style: TextStyle(
                    fontSize: 10,
                    color: unlocked
                        ? theme.colorScheme.primary
                        : theme.hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(DateTime? t) {
    if (t == null) return '';
    final l = t.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')}';
  }
}

final _unlockedProvider = StreamProvider(
  (ref) => ref.watch(gamificationServiceProvider).watchUnlocked(),
);
