import 'package:flutter/material.dart';

class StringListInput extends StatefulWidget {
  final String label;
  final String hint;
  final String addLabel;
  final List<String> items;
  final void Function(String) onAdd;
  final void Function(String) onRemove;

  const StringListInput({
    super.key,
    required this.label,
    required this.hint,
    required this.addLabel,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<StringListInput> createState() => _StringListInputState();
}

class _StringListInputState extends State<StringListInput> {
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
