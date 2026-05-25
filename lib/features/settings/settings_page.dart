import 'package:flutter/material.dart';

import '../../core/settings/app_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final s = settings.strings;

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                s.settingsLanguage,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: RadioGroup<AppLanguage>(
                  groupValue: settings.language,
                  onChanged: (v) {
                    if (v != null) settings.setLanguage(v);
                  },
                  child: Column(
                    children: [
                      RadioListTile<AppLanguage>(
                        title: Text(s.languagePtBR),
                        value: AppLanguage.ptBR,
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      RadioListTile<AppLanguage>(
                        title: Text(s.languageEn),
                        value: AppLanguage.en,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
