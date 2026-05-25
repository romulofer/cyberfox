import 'package:flutter/widgets.dart';

import '../l10n/app_strings.dart';

enum AppLanguage { ptBR, en }

class AppSettings extends ChangeNotifier {
  AppLanguage _language = AppLanguage.ptBR;

  AppLanguage get language => _language;

  AppStrings get strings =>
      _language == AppLanguage.ptBR ? AppStrings.ptBR : AppStrings.en;

  void setLanguage(AppLanguage lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }
}

class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static AppSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppSettingsScope>()!.notifier!;

  static AppStrings stringsOf(BuildContext context) => of(context).strings;
}
