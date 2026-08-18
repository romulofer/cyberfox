import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/models/section_template.dart';
import '../../../core/state/templates_store.dart';

/// Dropdown + apply button shown under a form section when templates exist
/// for it. Applying appends the template content to the section — it never
/// replaces what the user already typed.
class ApplyTemplate extends StatefulWidget {
  final AppStrings s;
  final TemplateSectionKey section;
  final void Function(SectionContent content) onApply;

  const ApplyTemplate({
    super.key,
    required this.s,
    required this.section,
    required this.onApply,
  });

  @override
  State<ApplyTemplate> createState() => _ApplyTemplateState();
}

class _ApplyTemplateState extends State<ApplyTemplate> {
  SectionTemplate? _selected;

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final templates = TemplatesScope.of(context).forSection(widget.section);
    if (templates.isEmpty) return const SizedBox.shrink();

    final selected =
        templates.contains(_selected) ? _selected : templates.first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<SectionTemplate>(
              initialValue: selected,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: s.templatesLabel,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              items: templates
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selected = v),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: selected == null
                ? null
                : () => widget.onApply(selected.content),
            child: Text(s.templateApply),
          ),
        ],
      ),
    );
  }
}
