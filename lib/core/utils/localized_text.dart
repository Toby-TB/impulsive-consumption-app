import 'dart:convert';
import 'dart:ui';

/// 应用支持的三种语言。
enum AppLanguage { en, zhHans, zhHant }

extension AppLanguageX on AppLanguage {
  Locale get locale => switch (this) {
        AppLanguage.en => const Locale('en'),
        AppLanguage.zhHans => const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans'),
        AppLanguage.zhHant => const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant'),
      };

  static AppLanguage fromLocale(Locale l) {
    if (l.languageCode != 'zh') return AppLanguage.en;
    return l.scriptCode == 'Hant' ? AppLanguage.zhHant : AppLanguage.zhHans;
  }
}

/// 三语文本值对象，数据库中以 JSON 字符串存储。
class LocalizedText {
  final String en;
  final String zhHans;
  final String zhHant;

  const LocalizedText({
    required this.en,
    required this.zhHans,
    required this.zhHant,
  });

  String of(AppLanguage lang) => switch (lang) {
        AppLanguage.en => en,
        AppLanguage.zhHans => zhHans,
        AppLanguage.zhHant => zhHant,
      };

  factory LocalizedText.fromJsonString(String raw) {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return LocalizedText(
      en: (j['en'] ?? '') as String,
      zhHans: (j['zhHans'] ?? j['zh'] ?? '') as String,
      zhHant: (j['zhHant'] ?? j['zhTw'] ?? '') as String,
    );
  }

  String toJsonString() =>
      jsonEncode({'en': en, 'zhHans': zhHans, 'zhHant': zhHant});
}

/// 标签列表，数据库中以 JSON 数组字符串存储。
class StringList {
  final List<String> values;

  const StringList(this.values);

  bool anyMatch(List<String> patterns) => patterns.any((p) =>
      values.any((v) => v.toLowerCase().contains(p.toLowerCase())));

  factory StringList.fromJsonString(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return StringList(list.cast<String>());
  }

  String toJsonString() => jsonEncode(values);
}
