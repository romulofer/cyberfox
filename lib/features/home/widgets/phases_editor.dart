import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/models/project_phase.dart';
import 'string_list_input.dart';

class PhasesEditor extends StatefulWidget {
  final AppStrings s;
  final List<ProjectPhase> items;
  final void Function(ProjectPhase) onAdd;
  final void Function(ProjectPhase) onRemove;

  const PhasesEditor({
    super.key,
    required this.s,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<PhasesEditor> createState() => _PhasesEditorState();
}

class _PhasesEditorState extends State<PhasesEditor> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _draftTasks = <String>[];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onAdd(ProjectPhase(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      tasks: List.of(_draftTasks),
    ));
    setState(() {
      _nameController.clear();
      _descriptionController.clear();
      _draftTasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: s.fieldPhaseName,
            hintText: s.hintPhaseName,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: s.fieldPhaseDescription,
            hintText: s.hintPhaseDescription,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        StringListInput(
          label: s.fieldPhaseTask,
          hint: s.hintPhaseTask,
          addLabel: s.add,
          items: _draftTasks,
          onAdd: (v) => setState(() => _draftTasks.add(v)),
          onRemove: (v) => setState(() => _draftTasks.remove(v)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.add, size: 18),
            label: Text(s.addPhase),
          ),
        ),
        if (widget.items.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...widget.items.map((phase) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      phase.name.isNotEmpty ? phase.name : s.fieldPhaseName,
                      style: const TextStyle(fontSize: 13),
                    ),
                    subtitle: Text(
                      '${phase.tasks.length} · ${s.fieldPhaseTask}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => widget.onRemove(phase),
                    ),
                  ),
                ),
              )),
        ],
      ],
    );
  }
}
