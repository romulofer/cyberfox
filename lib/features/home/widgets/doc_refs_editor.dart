import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/models/documentation_reference.dart';

class DocRefsEditor extends StatefulWidget {
  final AppStrings s;
  final List<DocumentationReference> items;
  final void Function(DocumentationReference) onAdd;
  final void Function(DocumentationReference) onRemove;

  const DocRefsEditor({
    super.key,
    required this.s,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<DocRefsEditor> createState() => _DocRefsEditorState();
}

class _DocRefsEditorState extends State<DocRefsEditor> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.isEmpty || _urlController.text.isEmpty) return;
    widget.onAdd(DocumentationReference(
      title: _titleController.text.trim(),
      url: _urlController.text.trim(),
      description: _descriptionController.text.trim(),
    ));
    _titleController.clear();
    _urlController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: s.fieldDocTitle,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _urlController,
          decoration: InputDecoration(
            labelText: s.fieldDocUrl,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: s.fieldDocDescriptionOptional,
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
          ...widget.items.map((doc) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    dense: true,
                    title:
                        Text(doc.title, style: const TextStyle(fontSize: 13)),
                    subtitle: Text(doc.url,
                        style: const TextStyle(fontSize: 11),
                        overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => widget.onRemove(doc),
                    ),
                  ),
                ),
              )),
        ],
      ],
    );
  }
}
