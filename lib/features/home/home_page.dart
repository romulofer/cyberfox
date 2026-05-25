import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/generators/markdown_generator.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/models/ai_target.dart';
import '../../core/models/documentation_reference.dart';
import '../../core/models/project_config.dart';
import '../../core/models/setup_command.dart';
import '../../core/models/tech_stack_entry.dart';
import '../../core/settings/app_settings.dart';
import '../settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Project
  final _projectController = TextEditingController();
  final _descriptionController = TextEditingController();
  AiTarget _selectedAi = aiTargets.first;

  // Tech stack
  final _techCategoryController = TextEditingController();
  final _techNameController = TextEditingController();
  final _techVersionController = TextEditingController();
  final List<TechStackEntry> _techStack = [];

  // Setup commands
  final _commandController = TextEditingController();
  final _commandDescriptionController = TextEditingController();
  final List<SetupCommand> _setupCommands = [];
  final List<String> _coreFeatures = [];
  final List<String> _acceptanceCriteria = [];
  final List<String> _whatNotToDo = [];

  // Documentation references
  final _docTitleController = TextEditingController();
  final _docUrlController = TextEditingController();
  final _docDescriptionController = TextEditingController();
  final List<DocumentationReference> _docs = [];

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _projectController.addListener(_onChanged);
    _descriptionController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _projectController.dispose();
    _descriptionController.dispose();
    _techCategoryController.dispose();
    _techNameController.dispose();
    _techVersionController.dispose();
    _commandController.dispose();
    _commandDescriptionController.dispose();
    _docTitleController.dispose();
    _docUrlController.dispose();
    _docDescriptionController.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  ProjectConfig get _config => ProjectConfig(
        projectName: _projectController.text,
        description: _descriptionController.text,
        targetAi: _selectedAi,
        techStack: _techStack,
        setupCommands: _setupCommands,
        coreFeatures: _coreFeatures,
        acceptanceCriteria: _acceptanceCriteria,
        whatNotToDo: _whatNotToDo,
        documentationReferences: _docs,
      );

  String get _markdown => MarkdownGenerator().generate(_config);

  void _addTechEntry() {
    if (_techCategoryController.text.isEmpty ||
        _techNameController.text.isEmpty) {
      return;
    }
    setState(() {
      _techStack.add(TechStackEntry(
        category: _techCategoryController.text.trim(),
        technology: _techNameController.text.trim(),
        versionOrNotes: _techVersionController.text.trim(),
      ));
      _techCategoryController.clear();
      _techNameController.clear();
      _techVersionController.clear();
    });
  }

  void _addCommand() {
    if (_commandController.text.isEmpty) return;
    setState(() {
      _setupCommands.add(SetupCommand(
        command: _commandController.text.trim(),
        description: _commandDescriptionController.text.trim(),
      ));
      _commandController.clear();
      _commandDescriptionController.clear();
    });
  }

  void _addDoc() {
    if (_docTitleController.text.isEmpty || _docUrlController.text.isEmpty) {
      return;
    }
    setState(() {
      _docs.add(DocumentationReference(
        title: _docTitleController.text.trim(),
        url: _docUrlController.text.trim(),
        description: _docDescriptionController.text.trim(),
      ));
      _docTitleController.clear();
      _docUrlController.clear();
      _docDescriptionController.clear();
    });
  }

  Future<void> _saveMarkdown() async {
    final s = AppSettingsScope.stringsOf(context);
    setState(() => _saving = true);
    try {
      final directory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: s.chooseFolderTitle,
      );
      if (directory == null) return;

      final filename = _selectedAi.filename;
      final file = File('$directory/$filename');
      await file.writeAsString(_markdown, encoding: utf8);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.savedAt('$directory/$filename')),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final s2 = AppSettingsScope.stringsOf(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s2.saveError(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSettingsScope.stringsOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyberfox'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FilledButton.icon(
              onPressed: _saving ? null : _saveMarkdown,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_alt),
              label: Text(
                  _saving ? s.saving : s.saveFileLabel(_selectedAi.filename)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: s.settingsTitle,
            onPressed: _openSettings,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 440,
            child: ColoredBox(
              color: colorScheme.surfaceContainerLow,
              child: _buildFormPanel(s),
            ),
          ),
          VerticalDivider(
              width: 1, thickness: 1, color: colorScheme.outlineVariant),
          Expanded(child: _buildPreviewPanel(s)),
        ],
      ),
    );
  }

  Widget _buildFormPanel(AppStrings s) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(s.sectionProject),
          const SizedBox(height: 12),
          TextField(
            controller: _projectController,
            decoration: InputDecoration(
              labelText: s.fieldName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: s.fieldDescription,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: InputDecoration(
              labelText: s.fieldTargetAi,
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            child: DropdownButton<AiTarget>(
              value: _selectedAi,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: aiTargets
                  .map((ai) => DropdownMenuItem(
                        value: ai,
                        child: Text('${ai.name}  —  ${ai.filename}'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedAi = value);
              },
            ),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionTechStack),
          const SizedBox(height: 12),
          TextField(
            controller: _techCategoryController,
            decoration: InputDecoration(
              labelText: s.fieldCategory,
              hintText: s.hintCategory,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _techNameController,
            decoration: InputDecoration(
              labelText: s.fieldTechnology,
              hintText: s.hintTechnology,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _techVersionController,
            onSubmitted: (_) => _addTechEntry(),
            decoration: InputDecoration(
              labelText: s.fieldVersionNotes,
              hintText: s.hintVersionNotes,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addTechEntry,
              icon: const Icon(Icons.add, size: 18),
              label: Text(s.add),
            ),
          ),
          if (_techStack.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._techStack.map((e) => _TechEntryTile(
                  entry: e,
                  onDelete: () => setState(() => _techStack.remove(e)),
                )),
          ],

          const SizedBox(height: 28),
          _SectionHeader(s.sectionSetupCommands),
          const SizedBox(height: 12),
          TextField(
            controller: _commandController,
            decoration: InputDecoration(
              labelText: s.fieldCommand,
              hintText: s.hintCommand,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commandDescriptionController,
            onSubmitted: (_) => _addCommand(),
            decoration: InputDecoration(
              labelText: s.fieldCommandDescription,
              hintText: s.hintCommandDescription,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addCommand,
              icon: const Icon(Icons.add, size: 18),
              label: Text(s.add),
            ),
          ),
          if (_setupCommands.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._setupCommands.map((cmd) => _SetupCommandTile(
                  command: cmd,
                  onDelete: () => setState(() => _setupCommands.remove(cmd)),
                )),
          ],

          const SizedBox(height: 28),
          _SectionHeader(s.sectionCoreFeatures),
          const SizedBox(height: 12),
          _StringListInput(
            label: s.fieldFeature,
            hint: s.hintFeature,
            items: _coreFeatures,
            addLabel: s.add,
            onAdd: (v) => setState(() => _coreFeatures.add(v)),
            onRemove: (v) => setState(() => _coreFeatures.remove(v)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionAcceptanceCriteria),
          const SizedBox(height: 12),
          _StringListInput(
            label: s.fieldCriterion,
            hint: s.hintCriterion,
            items: _acceptanceCriteria,
            addLabel: s.add,
            onAdd: (v) => setState(() => _acceptanceCriteria.add(v)),
            onRemove: (v) => setState(() => _acceptanceCriteria.remove(v)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionWhatNotToDo),
          const SizedBox(height: 12),
          _StringListInput(
            label: s.fieldProhibition,
            hint: s.hintProhibition,
            items: _whatNotToDo,
            addLabel: s.add,
            onAdd: (v) => setState(() => _whatNotToDo.add(v)),
            onRemove: (v) => setState(() => _whatNotToDo.remove(v)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionDocRefs),
          const SizedBox(height: 12),
          TextField(
            controller: _docTitleController,
            decoration: InputDecoration(
              labelText: s.fieldDocTitle,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _docUrlController,
            decoration: InputDecoration(
              labelText: s.fieldDocUrl,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _docDescriptionController,
            onSubmitted: (_) => _addDoc(),
            decoration: InputDecoration(
              labelText: s.fieldDocDescriptionOptional,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addDoc,
              icon: const Icon(Icons.add, size: 18),
              label: Text(s.add),
            ),
          ),
          if (_docs.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._docs.map((doc) => _DocTile(
                  doc: doc,
                  onDelete: () => setState(() => _docs.remove(doc)),
                )),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel(AppStrings s) {
    final markdown = _markdown;
    final colorScheme = Theme.of(context).colorScheme;

    if (markdown.trim().isEmpty) {
      return Center(
        child: Text(
          s.previewPlaceholder,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Markdown(
      data: markdown,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .labelLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _StringListInput extends StatefulWidget {
  final String label;
  final String hint;
  final String addLabel;
  final List<String> items;
  final void Function(String) onAdd;
  final void Function(String) onRemove;

  const _StringListInput({
    required this.label,
    required this.hint,
    required this.addLabel,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<_StringListInput> createState() => _StringListInputState();
}

class _StringListInputState extends State<_StringListInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onAdd(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              onPressed: _submit,
              icon: const Icon(Icons.add, size: 18),
              tooltip: widget.addLabel,
            ),
          ],
        ),
        if (widget.items.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...widget.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(item, style: const TextStyle(fontSize: 13)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => widget.onRemove(item),
                    ),
                  ),
                ),
              )),
        ],
      ],
    );
  }
}

class _SetupCommandTile extends StatelessWidget {
  final SetupCommand command;
  final VoidCallback onDelete;

  const _SetupCommandTile({required this.command, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          dense: true,
          title: Text(command.command, style: const TextStyle(fontSize: 13)),
          subtitle: command.description.isNotEmpty
              ? Text(command.description, style: const TextStyle(fontSize: 11))
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

class _TechEntryTile extends StatelessWidget {
  final TechStackEntry entry;
  final VoidCallback onDelete;

  const _TechEntryTile({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          dense: true,
          title: Text('${entry.category}  ·  ${entry.technology}',
              style: const TextStyle(fontSize: 13)),
          subtitle: entry.versionOrNotes.isNotEmpty
              ? Text(entry.versionOrNotes, style: const TextStyle(fontSize: 11))
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}

class _DocTile extends StatelessWidget {
  final DocumentationReference doc;
  final VoidCallback onDelete;

  const _DocTile({required this.doc, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          dense: true,
          title: Text(doc.title, style: const TextStyle(fontSize: 13)),
          subtitle: Text(doc.url,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
