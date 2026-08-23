import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/preferences_provider.dart';
import '../../../core/utils/localized_text.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/common.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(languageProvider);
    final region = ref.watch(regionProvider);
    final themePref = ref.watch(themePrefProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: l.language),
          Card(
            child: RadioGroup<AppLanguage>(
              groupValue: lang ?? AppLanguage.en,
              onChanged: (v) => ref.read(languageProvider.notifier).state = v,
              child: Column(
                children: [
                  _RadioTile<AppLanguage>(
                    title: l.langEn,
                    value: AppLanguage.en,
                  ),
                  _RadioTile<AppLanguage>(
                    title: l.langZhHant,
                    value: AppLanguage.zhHant,
                  ),
                  _RadioTile<AppLanguage>(
                    title: l.langZhHans,
                    value: AppLanguage.zhHans,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          _SectionHeader(title: l.regionCurrency),
          Card(
            child: RadioGroup<FxCurrency>(
              groupValue: region,
              onChanged: (v) {
                if (v != null) ref.read(regionProvider.notifier).state = v;
              },
              child: Column(
                children: [
                  _RadioTile<FxCurrency>(
                    title: l.regionCN,
                    value: FxCurrency.cny,
                  ),
                  _RadioTile<FxCurrency>(
                    title: l.regionUS,
                    value: FxCurrency.usd,
                  ),
                  _RadioTile<FxCurrency>(
                    title: l.regionHK,
                    value: FxCurrency.hkd,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          _SectionHeader(title: l.themeMode),
          Card(
            child: RadioGroup<ThemePref>(
              groupValue: themePref,
              onChanged: (v) {
                if (v != null) ref.read(themePrefProvider.notifier).state = v;
              },
              child: Column(
                children: [
                  _RadioTile<ThemePref>(
                    title: l.themeSystem,
                    value: ThemePref.system,
                  ),
                  _RadioTile<ThemePref>(
                    title: l.themeLight,
                    value: ThemePref.light,
                  ),
                  _RadioTile<ThemePref>(
                    title: l.themeDark,
                    value: ThemePref.dark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          _SectionHeader(title: l.about),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                l.aboutDisclaimer,
                style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: Theme.of(context).hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }
}

class _RadioTile<T> extends StatelessWidget {
  final String title;
  final T value;

  const _RadioTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      dense: true,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
