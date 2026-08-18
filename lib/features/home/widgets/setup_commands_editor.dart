import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/models/setup_command.dart';

class SetupCommandsEditor extends StatefulWidget {
  final AppStrings s;
  final List<SetupCommand> items;
  final void Function(SetupCommand) onAdd;
  final void Function(SetupCommand) onRemove;

  const SetupCommandsEditor({
    super.key,
    required this.s,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<SetupCommandsEditor> createState() => _SetupCommandsEditorState();
}

class _SetupCommandsEditorState extends State<SetupCommandsEditor> {
  final _commandController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _commandController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_commandController.text.isEmpty) return;
    widget.onAdd(SetupCommand(
      command: _commandController.text.trim(),
      description: _descriptionController.text.trim(),
    ));
    _commandController.clear();
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
          controller: _commandController,
          decoration: InputDecoration(
            labelText: s.fieldCommand,
            hintText: s.hintCommand,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          onSubmitted: (_) => _submit(),
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
            onPressed: _submit,
            icon: const Icon(Icons.add, size: 18),
            label: Text(s.add),
          ),
        ),
        if (widget.items.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...widget.items.map((cmd) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(cmd.command,
                        style: const TextStyle(fontSize: 13)),
                    subtitle: cmd.description.isNotEmpty
                        ? Text(cmd.description,
                            style: const TextStyle(fontSize: 11))
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => widget.onRemove(cmd),
                    ),
                  ),
                ),
              )),
        ],
      ],
    );
  }
}
