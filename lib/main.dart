import 'package:flutter/material.dart';

import 'core/settings/app_settings.dart';
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

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: _settings,
      child: MaterialApp(
        title: 'Cyberfox',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      ),
    );
  }
}
