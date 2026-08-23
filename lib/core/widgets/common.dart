import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/localized_text.dart';
import '../utils/money.dart';
import '../providers/preferences_provider.dart';
import '../../l10n/app_localizations.dart';

/// 通用金额文本：自动按所选地区币种换算展示。
class MoneyText extends ConsumerWidget {
  final int baseCents;
  final TextStyle? style;
  final FontWeight fontWeight;
  final Color? color;

  const MoneyText(
    this.baseCents, {
    super.key,
    this.style,
    this.fontWeight = FontWeight.w600,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(regionProvider);
    final locale = Localizations.localeOf(context).toString();
    return Text(
      formatMoney(baseCents, cur: region, locale: locale),
      style: (style ?? const TextStyle(fontSize: 15)).copyWith(
        fontWeight: fontWeight,
        color: color ?? const Color(0xFFE02020),
      ),
    );
  }
}

/// 三语文本快捷组件。
class LocalizedTextWidget extends StatelessWidget {
  final dynamic localized; // LocalizedText
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;

  const LocalizedTextWidget(
    this.localized, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLanguageX.fromLocale(Localizations.localeOf(context));
    return Text(
      localized.of(lang) as String,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// 当前语言。
AppLanguage currentLang(BuildContext context) =>
    AppLanguageX.fromLocale(Localizations.localeOf(context));

/// l10n 快捷方式。
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// 当前地区币种。
  FxCurrency watchRegion(WidgetRef ref) => ref.watch(regionProvider);
}
