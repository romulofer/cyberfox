import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/generators/markdown_generator.dart';
import '../../core/l10n/app_strings.dart';
import '../../core/models/ai_target.dart';
import '../../core/models/documentation_reference.dart';
import '../../core/models/project_config.dart';
import '../../core/models/project_phase.dart';
import '../../core/models/section_template.dart';
import '../../core/models/setup_command.dart';
import '../../core/models/tech_stack_entry.dart';
import '../../core/settings/app_settings.dart';
import '../settings/settings_page.dart';
import '../templates/templates_page.dart';
import 'widgets/apply_template.dart';
import 'widgets/doc_refs_editor.dart';
import 'widgets/phases_editor.dart';
import 'widgets/setup_commands_editor.dart';
import 'widgets/string_list_input.dart';
import 'widgets/tech_stack_editor.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final all = AppSettingsScope.of(context).allAgents;
    if (!all.contains(_selectedAi)) {
      _selectedAi = all.first;
    }
  }

  final List<TechStackEntry> _techStack = [];
  final List<SetupCommand> _setupCommands = [];
  final List<String> _coreFeatures = [];
  final List<ProjectPhase> _phases = [];
  final List<String> _acceptanceCriteria = [];
  final List<String> _whatToDo = [];
  final List<String> _whatNotToDo = [];
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
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _clearAll() {
    setState(() {
      _projectController.clear();
      _descriptionController.clear();
      _selectedAi = aiTargets.first;
      _techStack.clear();
      _setupCommands.clear();
      _coreFeatures.clear();
      _phases.clear();
      _acceptanceCriteria.clear();
      _whatToDo.clear();
      _whatNotToDo.clear();
      _docs.clear();
    });
  }

  ProjectConfig get _config => ProjectConfig(
        projectName: _projectController.text,
        description: _descriptionController.text,
        targetAi: _selectedAi,
        techStack: _techStack,
        setupCommands: _setupCommands,
        coreFeatures: _coreFeatures,
        phases: _phases,
        acceptanceCriteria: _acceptanceCriteria,
        whatToDo: _whatToDo,
        whatNotToDo: _whatNotToDo,
        documentationReferences: _docs,
      );

  String _markdown(AppStrings s) => MarkdownGenerator().generate(_config, s);

  void _applyToSection(TemplateSectionKey section, SectionContent content) {
    setState(() {
      switch (section) {
        case TemplateSectionKey.description:
          final addition = content.text ?? '';
          if (addition.isEmpty) return;
          _descriptionController.text = _descriptionController.text.isEmpty
              ? addition
              : '${_descriptionController.text}\n$addition';
        case TemplateSectionKey.techStack:
          _techStack.addAll(content.techStack ?? const []);
        case TemplateSectionKey.setupCommands:
          _setupCommands.addAll(content.setupCommands ?? const []);
        case TemplateSectionKey.coreFeatures:
          _coreFeatures.addAll(content.strings ?? const []);
        case TemplateSectionKey.phases:
          _phases.addAll(content.phases ?? const []);
        case TemplateSectionKey.acceptanceCriteria:
          _acceptanceCriteria.addAll(content.strings ?? const []);
        case TemplateSectionKey.whatToDo:
          _whatToDo.addAll(content.strings ?? const []);
        case TemplateSectionKey.whatNotToDo:
          _whatNotToDo.addAll(content.strings ?? const []);
        case TemplateSectionKey.documentationReferences:
          _docs.addAll(content.docs ?? const []);
      }
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
      await file.writeAsString(_markdown(s), encoding: utf8);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.savedAt('$directory/$filename')),
          duration: const Duration(seconds: 4),
        ),
      );

      if (!mounted) return;
      final shouldClear = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          final ds = AppSettingsScope.stringsOf(ctx);
          return AlertDialog(
            title: Text(ds.clearDialogTitle),
            content: Text(ds.clearDialogContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(ds.clearDialogCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(ds.clearDialogConfirm),
              ),
            ],
          );
        },
      );
      if (shouldClear == true) _clearAll();
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

  void _openTemplates() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TemplatesPage()),
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
            icon: const Icon(Icons.bookmark_border),
            tooltip: s.templatesLabel,
            onPressed: _openTemplates,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: s.settingsTitle,
            onPressed: _openSettings,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _ResizableSplit(
        left: ColoredBox(
          color: colorScheme.surfaceContainerLow,
          child: _buildFormPanel(s),
        ),
        right: _buildPreviewPanel(s),
        initialWidth: 440,
        minLeftWidth: 320,
        minRightWidth: 320,
        dividerColor: colorScheme.outlineVariant,
      ),
    );
  }

  Widget _buildFormPanel(AppStrings s) {
    final allAgents = AppSettingsScope.of(context).allAgents;

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
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.description,
            onApply: (c) =>
                _applyToSection(TemplateSectionKey.description, c),
          ),
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
              items: allAgents
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
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.techStack,
            onApply: (c) => _applyToSection(TemplateSectionKey.techStack, c),
          ),
          TechStackEditor(
            s: s,
            items: _techStack,
            onAdd: (e) => setState(() => _techStack.add(e)),
            onRemove: (e) => setState(() => _techStack.remove(e)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionSetupCommands),
          const SizedBox(height: 12),
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.setupCommands,
            onApply: (c) =>
                _applyToSection(TemplateSectionKey.setupCommands, c),
          ),
          SetupCommandsEditor(
            s: s,
            items: _setupCommands,
            onAdd: (e) => setState(() => _setupCommands.add(e)),
            onRemove: (e) => setState(() => _setupCommands.remove(e)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionCoreFeatures),
          const SizedBox(height: 12),
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.coreFeatures,
            onApply: (c) =>
                _applyToSection(TemplateSectionKey.coreFeatures, c),
          ),
          StringListInput(
            label: s.fieldFeature,
            hint: s.hintFeature,
            items: _coreFeatures,
            addLabel: s.add,
            onAdd: (v) => setState(() => _coreFeatures.add(v)),
            onRemove: (v) => setState(() => _coreFeatures.remove(v)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionPhases),
          const SizedBox(height: 12),
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.phases,
            onApply: (c) => _applyToSection(TemplateSectionKey.phases, c),
          ),
          PhasesEditor(
            s: s,
            items: _phases,
            onAdd: (p) => setState(() => _phases.add(p)),
            onRemove: (p) => setState(() => _phases.remove(p)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionAcceptanceCriteria),
          const SizedBox(height: 12),
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.acceptanceCriteria,
            onApply: (c) =>
                _applyToSection(TemplateSectionKey.acceptanceCriteria, c),
          ),
          StringListInput(
            label: s.fieldCriterion,
            hint: s.hintCriterion,
            items: _acceptanceCriteria,
            addLabel: s.add,
            onAdd: (v) => setState(() => _acceptanceCriteria.add(v)),
            onRemove: (v) => setState(() => _acceptanceCriteria.remove(v)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionWhatToDo),
          const SizedBox(height: 12),
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.whatToDo,
            onApply: (c) => _applyToSection(TemplateSectionKey.whatToDo, c),
          ),
          StringListInput(
            label: s.fieldGuideline,
            hint: s.hintGuideline,
            items: _whatToDo,
            addLabel: s.add,
            onAdd: (v) => setState(() => _whatToDo.add(v)),
            onRemove: (v) => setState(() => _whatToDo.remove(v)),
          ),

          const SizedBox(height: 28),
          _SectionHeader(s.sectionWhatNotToDo),
          const SizedBox(height: 12),
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.whatNotToDo,
            onApply: (c) =>
                _applyToSection(TemplateSectionKey.whatNotToDo, c),
          ),
          StringListInput(
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
          ApplyTemplate(
            s: s,
            section: TemplateSectionKey.documentationReferences,
            onApply: (c) => _applyToSection(
                TemplateSectionKey.documentationReferences, c),
          ),
          DocRefsEditor(
            s: s,
            items: _docs,
            onAdd: (d) => setState(() => _docs.add(d)),
            onRemove: (d) => setState(() => _docs.remove(d)),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel(AppStrings s) {
    final markdown = _markdown(s);
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

/// A left/right split with a draggable divider. The drag state lives in its
/// own [State], separate from [HomePage]'s, so dragging only resizes the
/// [SizedBox] around the already-built [left]/[right] widgets instead of
/// rebuilding them (which would re-run markdown generation every frame).
class _ResizableSplit extends StatefulWidget {
  final Widget left;
  final Widget right;
  final double initialWidth;
  final double minLeftWidth;
  final double minRightWidth;
  final Color dividerColor;

  const _ResizableSplit({
    required this.left,
    required this.right,
    required this.initialWidth,
    required this.minLeftWidth,
    required this.minRightWidth,
    required this.dividerColor,
  });

  @override
  State<_ResizableSplit> createState() => _ResizableSplitState();
}

class _ResizableSplitState extends State<_ResizableSplit> {
  late double _width = widget.initialWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = math.max(
          widget.minLeftWidth,
          constraints.maxWidth - widget.minRightWidth,
        );
        final width = _width.clamp(widget.minLeftWidth, maxWidth);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: width, child: widget.left),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _width = (width + details.delta.dx)
                        .clamp(widget.minLeftWidth, maxWidth);
                  });
                },
                child: SizedBox(
                  width: 8,
                  child: Center(
                    child: VerticalDivider(
                        width: 1, thickness: 1, color: widget.dividerColor),
                  ),
                ),
              ),
            ),
            Expanded(child: widget.right),
          ],
        );
      },
    );
  }
}

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
