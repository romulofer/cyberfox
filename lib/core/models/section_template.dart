import 'documentation_reference.dart';
import 'project_phase.dart';
import 'setup_command.dart';
import 'tech_stack_entry.dart';

/// Sections whose content can be saved and reused as a template. The
/// project title is intentionally excluded — templates cover repeatable
/// content only.
enum TemplateSectionKey {
  description,
  techStack,
  setupCommands,
  coreFeatures,
  phases,
  acceptanceCriteria,
  whatToDo,
  whatNotToDo,
  documentationReferences,
}

/// Sections whose content is a plain list of strings; they share one editor
/// and one empty shape.
const _stringListSections = {
  TemplateSectionKey.coreFeatures,
  TemplateSectionKey.acceptanceCriteria,
  TemplateSectionKey.whatToDo,
  TemplateSectionKey.whatNotToDo,
};

bool isStringListSection(TemplateSectionKey section) =>
    _stringListSections.contains(section);

/// A template's content, typed by [TemplateSectionKey]. Only one of the
/// fields is populated, matching [section].
class SectionContent {
  final String? text;
  final List<String>? strings;
  final List<TechStackEntry>? techStack;
  final List<SetupCommand>? setupCommands;
  final List<ProjectPhase>? phases;
  final List<DocumentationReference>? docs;

  const SectionContent({
    this.text,
    this.strings,
    this.techStack,
    this.setupCommands,
    this.phases,
    this.docs,
  });

  factory SectionContent.empty(TemplateSectionKey section) {
    switch (section) {
      case TemplateSectionKey.description:
        return const SectionContent(text: '');
      case TemplateSectionKey.techStack:
        return const SectionContent(techStack: []);
      case TemplateSectionKey.setupCommands:
        return const SectionContent(setupCommands: []);
      case TemplateSectionKey.phases:
        return const SectionContent(phases: []);
      case TemplateSectionKey.documentationReferences:
        return const SectionContent(docs: []);
      case TemplateSectionKey.coreFeatures:
      case TemplateSectionKey.acceptanceCriteria:
      case TemplateSectionKey.whatToDo:
      case TemplateSectionKey.whatNotToDo:
        return const SectionContent(strings: []);
    }
  }

  dynamic toJson() {
    if (text != null) return text;
    if (strings != null) return strings;
    if (techStack != null) return techStack!.map((e) => e.toJson()).toList();
    if (setupCommands != null) {
      return setupCommands!.map((e) => e.toJson()).toList();
    }
    if (phases != null) return phases!.map((e) => e.toJson()).toList();
    if (docs != null) return docs!.map((e) => e.toJson()).toList();
    return null;
  }

  factory SectionContent.fromJson(TemplateSectionKey section, dynamic json) {
    switch (section) {
      case TemplateSectionKey.description:
        return SectionContent(text: json as String? ?? '');
      case TemplateSectionKey.techStack:
        return SectionContent(
          techStack: (json as List? ?? [])
              .map((e) => TechStackEntry.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      case TemplateSectionKey.setupCommands:
        return SectionContent(
          setupCommands: (json as List? ?? [])
              .map((e) => SetupCommand.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      case TemplateSectionKey.phases:
        return SectionContent(
          phases: (json as List? ?? [])
              .map((e) => ProjectPhase.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      case TemplateSectionKey.documentationReferences:
        return SectionContent(
          docs: (json as List? ?? [])
              .map((e) =>
                  DocumentationReference.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      case TemplateSectionKey.coreFeatures:
      case TemplateSectionKey.acceptanceCriteria:
      case TemplateSectionKey.whatToDo:
      case TemplateSectionKey.whatNotToDo:
        return SectionContent(strings: (json as List? ?? []).cast<String>());
    }
  }
}

class SectionTemplate {
  final String id;
  final TemplateSectionKey section;
  final String name;
  final SectionContent content;

  const SectionTemplate({
    required this.id,
    required this.section,
    required this.name,
    required this.content,
  });

  SectionTemplate copyWith({String? name, SectionContent? content}) =>
      SectionTemplate(
        id: id,
        section: section,
        name: name ?? this.name,
        content: content ?? this.content,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'section': section.name,
        'name': name,
        'content': content.toJson(),
      };

  factory SectionTemplate.fromJson(Map<String, dynamic> json) {
    final section = TemplateSectionKey.values.firstWhere(
      (s) => s.name == json['section'],
      orElse: () => TemplateSectionKey.description,
    );
    return SectionTemplate(
      id: json['id'] as String,
      section: section,
      name: json['name'] as String? ?? '',
      content: SectionContent.fromJson(section, json['content']),
    );
  }
}
