import '../../data/database/tables.dart';

/// 物流时间轴节点。
class LogisticsStep {
  final String labelKey; // 对应 l10n 的 stepPlaced/stepShipped/...
  final DateTime at;
  final bool reached;

  const LogisticsStep({
    required this.labelKey,
    required this.at,
    required this.reached,
  });
}

/// 纯函数物流推演：全部基于 paidAt 计算，无后台任务。
abstract final class LogisticsCalculator {
  static const shipAfter = Duration(seconds: 60);
  static const deliverAfter = Duration(seconds: 180);
  static const completeAfter = Duration(seconds: 360);

  static OrderStatus statusAt(DateTime paidAt, DateTime now) {
    final elapsed = now.difference(paidAt);
    if (elapsed >= completeAfter) return OrderStatus.completed;
    if (elapsed >= deliverAfter) return OrderStatus.delivering;
    if (elapsed >= shipAfter) return OrderStatus.shipping;
    return OrderStatus.pendingShip;
  }

  static List<LogisticsStep> timeline(DateTime paidAt, DateTime now) {
    final placed = paidAt;
    final shipped = paidAt.add(shipAfter);
    final transit = paidAt.add(const Duration(seconds: 90));
    final delivering = paidAt.add(deliverAfter);
    final signed = paidAt.add(completeAfter);

    bool reached(DateTime t) => !now.isBefore(t);

    return [
      LogisticsStep(labelKey: 'stepPlaced', at: placed, reached: reached(placed)),
      LogisticsStep(labelKey: 'stepShipped', at: shipped, reached: reached(shipped)),
      LogisticsStep(labelKey: 'stepTransit', at: transit, reached: reached(transit)),
      LogisticsStep(labelKey: 'stepDeliver', at: delivering, reached: reached(delivering)),
      LogisticsStep(labelKey: 'stepSigned', at: signed, reached: reached(signed)),
    ];
  }
}
