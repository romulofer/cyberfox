import 'package:flutter/material.dart';

import '../../core/models/ai_target.dart';
import '../../core/settings/app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _nameController = TextEditingController();
  final _filenameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _filenameController.dispose();
    super.dispose();
  }

  void _addAgent(AppSettings settings) {
    final name = _nameController.text.trim();
    final filename = _filenameController.text.trim();
    if (name.isEmpty || filename.isEmpty) return;
    settings.addCustomAgent(AiTarget(name: name, filename: filename));
    _nameController.clear();
    _filenameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final s = settings.strings;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // ── Language ────────────────────────────────────────────────
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
                  side: BorderSide(color: colorScheme.outlineVariant),
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
                      Divider(height: 1, color: colorScheme.outlineVariant),
                      RadioListTile<AppLanguage>(
                        title: Text(s.languageEn),
                        value: AppLanguage.en,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Theme ───────────────────────────────────────────────────
              Text(
                s.settingsTheme,
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
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: RadioGroup<AppThemeMode>(
                  groupValue: settings.themeMode,
                  onChanged: (v) {
                    if (v != null) settings.setThemeMode(v);
                  },
                  child: Column(
                    children: [
                      RadioListTile<AppThemeMode>(
                        title: Text(s.themeSystem),
                        value: AppThemeMode.system,
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant),
                      RadioListTile<AppThemeMode>(
                        title: Text(s.themeLight),
                        value: AppThemeMode.light,
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant),
                      RadioListTile<AppThemeMode>(
                        title: Text(s.themeDark),
                        value: AppThemeMode.dark,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Custom Agents ────────────────────────────────────────────
              Text(
                s.sectionCustomAgents,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: s.fieldAgentName,
                  hintText: s.hintAgentName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _filenameController,
                onSubmitted: (_) => _addAgent(settings),
                decoration: InputDecoration(
                  labelText: s.fieldAgentFilename,
                  hintText: s.hintAgentFilename,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _addAgent(settings),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(s.add),
                ),
              ),
              if (settings.customAgents.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < settings.customAgents.length; i++) ...[
                        if (i > 0)
                          Divider(height: 1, color: colorScheme.outlineVariant),
                        ListTile(
                          title: Text(settings.customAgents[i].name),
                          subtitle: Text(
                            settings.customAgents[i].filename,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => settings
                                .removeCustomAgent(settings.customAgents[i]),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
