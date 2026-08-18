import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/models/tech_stack_entry.dart';

class TechStackEditor extends StatefulWidget {
  final AppStrings s;
  final List<TechStackEntry> items;
  final void Function(TechStackEntry) onAdd;
  final void Function(TechStackEntry) onRemove;

  const TechStackEditor({
    super.key,
    required this.s,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<TechStackEditor> createState() => _TechStackEditorState();
}

class _TechStackEditorState extends State<TechStackEditor> {
  final _categoryController = TextEditingController();
  final _nameController = TextEditingController();
  final _versionController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _nameController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_categoryController.text.isEmpty || _nameController.text.isEmpty) {
      return;
    }
    widget.onAdd(TechStackEntry(
      category: _categoryController.text.trim(),
      technology: _nameController.text.trim(),
      versionOrNotes: _versionController.text.trim(),
    ));
    _categoryController.clear();
    _nameController.clear();
    _versionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _categoryController,
          decoration: InputDecoration(
            labelText: s.fieldCategory,
            hintText: s.hintCategory,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: s.fieldTechnology,
            hintText: s.hintTechnology,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _versionController,
          onSubmitted: (_) => _submit(),
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
            onPressed: _submit,
            icon: const Icon(Icons.add, size: 18),
            label: Text(s.add),
          ),
        ),
        if (widget.items.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...widget.items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text('${e.category}  ·  ${e.technology}',
                        style: const TextStyle(fontSize: 13)),
                    subtitle: e.versionOrNotes.isNotEmpty
                        ? Text(e.versionOrNotes,
                            style: const TextStyle(fontSize: 11))
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => widget.onRemove(e),
                    ),
                  ),
                ),
              )),
        ],
      ],
    );
  }
}
