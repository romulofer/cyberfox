import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/models/documentation_reference.dart';
import '../../core/models/project_phase.dart';
import '../../core/models/section_template.dart';
import '../../core/models/setup_command.dart';
import '../../core/models/tech_stack_entry.dart';
import '../../core/settings/app_settings.dart';
import '../../core/state/templates_store.dart';
import '../home/widgets/doc_refs_editor.dart';
import '../home/widgets/phases_editor.dart';
import '../home/widgets/setup_commands_editor.dart';
import '../home/widgets/string_list_input.dart';
import '../home/widgets/tech_stack_editor.dart';

String sectionLabel(TemplateSectionKey section, AppStrings s) {
  switch (section) {
    case TemplateSectionKey.description:
      return s.fieldDescription;
    case TemplateSectionKey.techStack:
      return s.sectionTechStack;
    case TemplateSectionKey.setupCommands:
      return s.sectionSetupCommands;
    case TemplateSectionKey.coreFeatures:
      return s.sectionCoreFeatures;
    case TemplateSectionKey.phases:
      return s.sectionPhases;
    case TemplateSectionKey.acceptanceCriteria:
      return s.sectionAcceptanceCriteria;
    case TemplateSectionKey.whatToDo:
      return s.sectionWhatToDo;
    case TemplateSectionKey.whatNotToDo:
      return s.sectionWhatNotToDo;
    case TemplateSectionKey.documentationReferences:
      return s.sectionDocRefs;
  }
}

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  TemplateSectionKey _section = TemplateSectionKey.description;
  String? _editingId;

  List<String> _strings = [];
  List<TechStackEntry> _techStack = [];
  List<SetupCommand> _setupCommands = [];
  List<ProjectPhase> _phases = [];
  List<DocumentationReference> _docs = [];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm({TemplateSectionKey? section}) {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _section = section ?? _section;
      _descriptionController.clear();
      _strings = [];
      _techStack = [];
      _setupCommands = [];
      _phases = [];
      _docs = [];
    });
  }

  void _editTemplate(SectionTemplate t) {
    setState(() {
      _editingId = t.id;
      _section = t.section;
      _nameController.text = t.name;
      _descriptionController.text = t.content.text ?? '';
      _strings = List.of(t.content.strings ?? const []);
      _techStack = List.of(t.content.techStack ?? const []);
      _setupCommands = List.of(t.content.setupCommands ?? const []);
      _phases = List.of(t.content.phases ?? const []);
      _docs = List.of(t.content.docs ?? const []);
    });
  }

  SectionContent _buildContent() {
    switch (_section) {
      case TemplateSectionKey.description:
        return SectionContent(text: _descriptionController.text);
      case TemplateSectionKey.techStack:
        return SectionContent(techStack: _techStack);
      case TemplateSectionKey.setupCommands:
        return SectionContent(setupCommands: _setupCommands);
      case TemplateSectionKey.phases:
        return SectionContent(phases: _phases);
      case TemplateSectionKey.documentationReferences:
        return SectionContent(docs: _docs);
      case TemplateSectionKey.coreFeatures:
      case TemplateSectionKey.acceptanceCriteria:
      case TemplateSectionKey.whatToDo:
      case TemplateSectionKey.whatNotToDo:
        return SectionContent(strings: _strings);
    }
  }

  Future<void> _submit(TemplatesStore store) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final content = _buildContent();
    if (_editingId != null) {
      await store.update(SectionTemplate(
        id: _editingId!,
        section: _section,
        name: name,
        content: content,
      ));
    } else {
      await store.save(SectionTemplate(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        section: _section,
        name: name,
        content: content,
      ));
    }
    _resetForm();
  }

  Future<void> _export(BuildContext context, TemplatesStore store) async {
    final s = AppSettingsScope.stringsOf(context);
    final directory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: s.chooseFolderTitle,
    );
    if (directory == null) return;
    final file = File('$directory/cyberfox-templates-backup.json');
    await file.writeAsString(store.exportJson(), encoding: utf8);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.savedAt(file.path))),
    );
  }

  Future<void> _import(BuildContext context, TemplatesStore store) async {
    final s = AppSettingsScope.stringsOf(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final path = result?.files.single.path;
    if (path == null) return;
    try {
      final raw = await File(path).readAsString();
      final count = await store.importJson(raw);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${s.templateImport}: $count')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.saveError(e.toString()))),
      );
    }
  }

  Widget _contentEditor(AppStrings s) {
    switch (_section) {
      case TemplateSectionKey.description:
        return TextField(
          maxLines: 4,
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: s.fieldDescription,
            border: const OutlineInputBorder(),
          ),
        );
      case TemplateSectionKey.techStack:
        return TechStackEditor(
          s: s,
          items: _techStack,
          onAdd: (e) => setState(() => _techStack = [..._techStack, e]),
          onRemove: (e) =>
              setState(() => _techStack = _techStack.where((x) => x != e).toList()),
        );
      case TemplateSectionKey.setupCommands:
        return SetupCommandsEditor(
          s: s,
          items: _setupCommands,
          onAdd: (e) =>
              setState(() => _setupCommands = [..._setupCommands, e]),
          onRemove: (e) => setState(
              () => _setupCommands = _setupCommands.where((x) => x != e).toList()),
        );
      case TemplateSectionKey.phases:
        return PhasesEditor(
          s: s,
          items: _phases,
          onAdd: (p) => setState(() => _phases = [..._phases, p]),
          onRemove: (p) =>
              setState(() => _phases = _phases.where((x) => x != p).toList()),
        );
      case TemplateSectionKey.documentationReferences:
        return DocRefsEditor(
          s: s,
          items: _docs,
          onAdd: (d) => setState(() => _docs = [..._docs, d]),
          onRemove: (d) =>
              setState(() => _docs = _docs.where((x) => x != d).toList()),
        );
      case TemplateSectionKey.coreFeatures:
      case TemplateSectionKey.acceptanceCriteria:
      case TemplateSectionKey.whatToDo:
      case TemplateSectionKey.whatNotToDo:
        final label = switch (_section) {
          TemplateSectionKey.whatToDo => s.fieldGuideline,
          TemplateSectionKey.whatNotToDo => s.fieldProhibition,
          TemplateSectionKey.acceptanceCriteria => s.fieldCriterion,
          _ => s.fieldFeature,
        };
        return StringListInput(
          label: label,
          hint: '',
          addLabel: s.add,
          items: _strings,
          onAdd: (v) => setState(() => _strings = [..._strings, v]),
          onRemove: (v) =>
              setState(() => _strings = _strings.where((x) => x != v).toList()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSettingsScope.stringsOf(context);
    final store = TemplatesScope.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.templatesManageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: s.templateExport,
            onPressed: () => _export(context, store),
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: s.templateImport,
            onPressed: () => _import(context, store),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(s.templatesManageIntro,
                    style: TextStyle(color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 24),

                Text(
                  _editingId != null ? s.templateEdit : s.templateNew,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: s.templateSection,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButton<TemplateSectionKey>(
                    value: _section,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: TemplateSectionKey.values
                        .map((sec) => DropdownMenuItem(
                              value: sec,
                              child: Text(sectionLabel(sec, s)),
                            ))
                        .toList(),
                    onChanged: _editingId != null
                        ? null
                        : (v) {
                            if (v != null) _resetForm(section: v);
                          },
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: s.templateNamePlaceholder,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                _contentEditor(s),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (_editingId != null) ...[
                      OutlinedButton(
                        onPressed: _resetForm,
                        child: Text(s.templateCancel),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _submit(store),
                        child: Text(s.templateSave),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),
                Text(
                  s.templatesLabel,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (store.all.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(s.templateEmpty,
                        style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  )
                else
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < store.all.length; i++) ...[
                          if (i > 0)
                            Divider(
                                height: 1, color: colorScheme.outlineVariant),
                          ListTile(
                            title: Text(store.all[i].name),
                            subtitle: Text(sectionLabel(store.all[i].section, s)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 20),
                                  onPressed: () => _editTemplate(store.all[i]),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 20),
                                  tooltip: s.templateDelete,
                                  onPressed: () =>
                                      store.remove(store.all[i].id),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
