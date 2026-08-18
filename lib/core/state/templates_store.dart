import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/section_template.dart';

const _storageKey = 'cyberfox.templates.v1';

class TemplatesStore extends ChangeNotifier {
  List<SectionTemplate> _templates = [];
  bool _loaded = false;

  List<SectionTemplate> get all => List.unmodifiable(_templates);

  bool get loaded => _loaded;

  List<SectionTemplate> forSection(TemplateSectionKey section) =>
      _templates.where((t) => t.section == section).toList();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _templates = list
          .map((e) => SectionTemplate.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_templates.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  Future<void> save(SectionTemplate template) async {
    _templates = [..._templates, template];
    notifyListeners();
    await _persist();
  }

  Future<void> update(SectionTemplate template) async {
    _templates = _templates
        .map((t) => t.id == template.id ? template : t)
        .toList();
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String id) async {
    _templates = _templates.where((t) => t.id != id).toList();
    notifyListeners();
    await _persist();
  }

  /// Pretty-printed JSON of all templates, for backup export.
  String exportJson() =>
      const JsonEncoder.withIndent('  ').convert(_templates.map((t) => t.toJson()).toList());

  /// Imports templates from a backup JSON string produced by [exportJson].
  /// Imported templates get fresh ids so they never collide with existing
  /// ones; pass [replaceAll] to discard current templates instead of
  /// merging.
  Future<int> importJson(String raw, {bool replaceAll = false}) async {
    final list = jsonDecode(raw) as List;
    final imported = <SectionTemplate>[];
    for (var i = 0; i < list.length; i++) {
      final parsed =
          SectionTemplate.fromJson(list[i] as Map<String, dynamic>);
      imported.add(SectionTemplate(
        id: '${DateTime.now().microsecondsSinceEpoch}-$i',
        section: parsed.section,
        name: parsed.name,
        content: parsed.content,
      ));
    }
    _templates = replaceAll ? imported : [..._templates, ...imported];
    notifyListeners();
    await _persist();
    return imported.length;
  }
}

class TemplatesScope extends InheritedNotifier<TemplatesStore> {
  const TemplatesScope({
    super.key,
    required TemplatesStore store,
    required super.child,
  }) : super(notifier: store);

  static TemplatesStore of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<TemplatesScope>()!
      .notifier!;
}
