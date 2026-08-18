import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';

import '../l10n/app_strings.dart';
import '../models/ai_target.dart';

enum AppLanguage { ptBR, en }

enum AppThemeMode { system, light, dark }

class AppSettings extends ChangeNotifier {
  AppLanguage _language = AppLanguage.ptBR;
  AppThemeMode _themeMode = AppThemeMode.system;
  final List<AiTarget> _customAgents = [];

  AppLanguage get language => _language;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get flutterThemeMode => switch (_themeMode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };

  void setThemeMode(AppThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  List<AiTarget> get customAgents => List.unmodifiable(_customAgents);

  List<AiTarget> get allAgents => [...aiTargets, ..._customAgents];

  AppStrings get strings =>
      _language == AppLanguage.ptBR ? AppStrings.ptBR : AppStrings.en;

  void setLanguage(AppLanguage lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }

  void addCustomAgent(AiTarget agent) {
    _customAgents.add(agent);
    notifyListeners();
  }

  void removeCustomAgent(AiTarget agent) {
    _customAgents.remove(agent);
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
