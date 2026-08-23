import 'package:flutter/material.dart';

import '../../../data/services/logistics_calculator.dart';
import '../../../l10n/app_localizations.dart';

/// 垂直物流时间轴：节点随时间点亮。
class LogisticsTimeline extends StatelessWidget {
  final DateTime paidAt;
  final DateTime now;

  const LogisticsTimeline({
    super.key,
    required this.paidAt,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final steps = LogisticsCalculator.timeline(paidAt, now);

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 时间轴列
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: steps[i].reached
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      if (i != steps.length - 1)
                        Expanded(
                          child: Center(
                            widthFactor: 1,
                            child: Container(
                              width: 2,
                              color: steps[i + 1].reached
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // 内容列
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 22),
                    child: Row(
                      children: [
                        Text(
                          switch (steps[i].labelKey) {
                            'stepPlaced' => l.stepPlaced,
                            'stepShipped' => l.stepShipped,
                            'stepTransit' => l.stepTransit,
                            'stepDeliver' => l.stepDeliver,
                            _ => l.stepSigned,
                          },
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: steps[i].reached
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: steps[i].reached
                                ? null
                                : theme.hintColor,
                          ),
                        ),
                        const Spacer(),
                        if (steps[i].reached)
                          Text(
                            _fmt(steps[i].at),
                            style: TextStyle(
                                fontSize: 11, color: theme.hintColor),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _fmt(DateTime t) {
    final l = t.toLocal();
    return '${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')} '
        '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}
