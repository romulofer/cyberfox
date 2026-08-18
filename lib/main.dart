import 'package:flutter/material.dart';

import 'core/settings/app_settings.dart';
import 'core/state/templates_store.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const CyberfoxApp());
}

class CyberfoxApp extends StatefulWidget {
  const CyberfoxApp({super.key});

  @override
  State<CyberfoxApp> createState() => _CyberfoxAppState();
}

class _CyberfoxAppState extends State<CyberfoxApp> {
  final _settings = AppSettings();
  final _templates = TemplatesStore();

  @override
  void initState() {
    super.initState();
    _templates.load();
  }

  @override
  void dispose() {
    _settings.dispose();
    _templates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: _settings,
      child: TemplatesScope(
        store: _templates,
        child: AnimatedBuilder(
          animation: _settings,
          builder: (context, _) => MaterialApp(
            title: 'Cyberfox',
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _settings.flutterThemeMode,
          ),
        ),
      ),
    );
  }
}
