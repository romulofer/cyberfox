import 'package:cyberfox/core/generators/markdown_generator.dart';
import 'package:cyberfox/core/l10n/app_strings.dart';
import 'package:cyberfox/core/models/ai_target.dart';
import 'package:cyberfox/core/models/documentation_reference.dart';
import 'package:cyberfox/core/models/project_config.dart';
import 'package:cyberfox/core/models/project_phase.dart';
import 'package:cyberfox/core/models/setup_command.dart';
import 'package:cyberfox/core/models/tech_stack_entry.dart';
import 'package:flutter_test/flutter_test.dart';

ProjectConfig _config({
  String name = 'My Project',
  String description = '',
  List<TechStackEntry> techStack = const [],
  List<SetupCommand> setupCommands = const [],
  List<String> coreFeatures = const [],
  List<ProjectPhase> phases = const [],
  List<String> acceptanceCriteria = const [],
  List<String> whatToDo = const [],
  List<String> whatNotToDo = const [],
  List<DocumentationReference> documentationReferences = const [],
}) =>
    ProjectConfig(
      projectName: name,
      description: description,
      targetAi: const AiTarget(name: 'Test', filename: 'test.md'),
      techStack: techStack,
      setupCommands: setupCommands,
      coreFeatures: coreFeatures,
      phases: phases,
      acceptanceCriteria: acceptanceCriteria,
      whatToDo: whatToDo,
      whatNotToDo: whatNotToDo,
      documentationReferences: documentationReferences,
    );

void main() {
  final gen = MarkdownGenerator();

  group('project title and overview', () {
    test('outputs project name as h1', () {
      final out = gen.generate(_config(name: 'Awesome App'), AppStrings.en);
      expect(out, contains('# Awesome App'));
    });

    test('outputs description when provided', () {
      final out = gen.generate(_config(description: 'A cool tool'), AppStrings.en);
      expect(out, contains('A cool tool'));
    });

    test('omits description line when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      final nonHeadingLines = out.split('\n').where((l) => l.isNotEmpty && !l.startsWith('#'));
      expect(nonHeadingLines, isEmpty);
    });

    test('output has no trailing whitespace', () {
      final out = gen.generate(_config(coreFeatures: ['f']), AppStrings.en);
      expect(out, equals(out.trimRight()));
    });
  });

  group('tech stack', () {
    const entry = TechStackEntry(category: 'Backend', technology: 'Dart', versionOrNotes: '3.x');

    test('section is present when non-empty', () {
      final out = gen.generate(_config(techStack: [entry]), AppStrings.en);
      expect(out, contains('## Tech Stack'));
    });

    test('section is absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## Tech Stack')));
    });

    test('EN column headers', () {
      final out = gen.generate(_config(techStack: [entry]), AppStrings.en);
      expect(out, contains('| Category | Technology | Version / Notes |'));
    });

    test('PT-BR column headers', () {
      final out = gen.generate(_config(techStack: [entry]), AppStrings.ptBR);
      expect(out, contains('| Categoria | Tecnologia | Versão / Notas |'));
    });

    test('row data is written correctly', () {
      final out = gen.generate(_config(techStack: [entry]), AppStrings.en);
      expect(out, contains('| Backend | Dart | 3.x |'));
    });

    test('row with empty versionOrNotes writes empty cell', () {
      const e = TechStackEntry(category: 'DB', technology: 'SQLite');
      final out = gen.generate(_config(techStack: [e]), AppStrings.en);
      expect(out, contains('| DB | SQLite |  |'));
    });
  });

  group('setup commands', () {
    const cmd = SetupCommand(command: 'flutter pub get', description: 'Install deps');

    test('section is present when non-empty', () {
      final out = gen.generate(_config(setupCommands: [cmd]), AppStrings.en);
      expect(out, contains('## Setup Commands'));
    });

    test('section is absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## Setup Commands')));
    });

    test('EN column headers', () {
      final out = gen.generate(_config(setupCommands: [cmd]), AppStrings.en);
      expect(out, contains('| Command | Description |'));
    });

    test('PT-BR column headers', () {
      final out = gen.generate(_config(setupCommands: [cmd]), AppStrings.ptBR);
      expect(out, contains('| Comando | Descrição |'));
    });

    test('command is wrapped in backticks', () {
      final out = gen.generate(_config(setupCommands: [cmd]), AppStrings.en);
      expect(out, contains('| `flutter pub get` | Install deps |'));
    });
  });

  group('bullet-list sections', () {
    test('core features section present when non-empty', () {
      final out = gen.generate(_config(coreFeatures: ['Live preview']), AppStrings.en);
      expect(out, contains('## Core Features'));
      expect(out, contains('- Live preview'));
    });

    test('core features section absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## Core Features')));
    });

    test('what to do section present when non-empty', () {
      final out = gen.generate(_config(whatToDo: ['Validate all input']), AppStrings.en);
      expect(out, contains('## What To Do'));
      expect(out, contains('- Validate all input'));
    });

    test('what to do section absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## What To Do')));
    });

    test('acceptance criteria section present when non-empty', () {
      final out = gen.generate(_config(acceptanceCriteria: ['Tests pass']), AppStrings.en);
      expect(out, contains('## Acceptance Criteria'));
      expect(out, contains('- Tests pass'));
    });

    test('acceptance criteria section absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## Acceptance Criteria')));
    });

    test('what not to do section present when non-empty', () {
      final out = gen.generate(_config(whatNotToDo: ['No mocking DB']), AppStrings.en);
      expect(out, contains('## What Not To Do'));
      expect(out, contains('- No mocking DB'));
    });

    test('what not to do section absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## What Not To Do')));
    });

    test('multiple items all appear as bullet points', () {
      final out = gen.generate(
        _config(coreFeatures: ['Feature A', 'Feature B', 'Feature C']),
        AppStrings.en,
      );
      expect(out, contains('- Feature A'));
      expect(out, contains('- Feature B'));
      expect(out, contains('- Feature C'));
    });
  });

  group('phases', () {
    test('section present when non-empty', () {
      final out = gen.generate(
        _config(phases: [
          const ProjectPhase(name: 'MVP', description: 'Ship the basics', tasks: ['Set up CI']),
        ]),
        AppStrings.en,
      );
      expect(out, contains('## Project Phases'));
      expect(out, contains('### Phase 1: MVP'));
      expect(out, contains('Ship the basics'));
      expect(out, contains('- Set up CI'));
    });

    test('section absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## Project Phases')));
    });

    test('unnamed phase falls back to numeric label', () {
      final out = gen.generate(
        _config(phases: [const ProjectPhase()]),
        AppStrings.en,
      );
      expect(out, contains('### Phase 1'));
      expect(out, isNot(contains('### Phase 1:')));
    });

    test('multiple phases are numbered in order', () {
      final out = gen.generate(
        _config(phases: [
          const ProjectPhase(name: 'MVP'),
          const ProjectPhase(name: 'Beta'),
        ]),
        AppStrings.en,
      );
      expect(out, contains('### Phase 1: MVP'));
      expect(out, contains('### Phase 2: Beta'));
    });
  });

  group('documentation references', () {
    test('section present when non-empty', () {
      final out = gen.generate(
        _config(documentationReferences: [
          DocumentationReference(title: 'Flutter', url: 'https://flutter.dev', description: ''),
        ]),
        AppStrings.en,
      );
      expect(out, contains('## Documentation References'));
    });

    test('section absent when empty', () {
      final out = gen.generate(_config(), AppStrings.en);
      expect(out, isNot(contains('## Documentation References')));
    });

    test('title is rendered as h3', () {
      final out = gen.generate(
        _config(documentationReferences: [
          DocumentationReference(title: 'Flutter Docs', url: 'https://flutter.dev', description: ''),
        ]),
        AppStrings.en,
      );
      expect(out, contains('### Flutter Docs'));
    });

    test('URL is rendered as a markdown link', () {
      final out = gen.generate(
        _config(documentationReferences: [
          DocumentationReference(title: 'Flutter Docs', url: 'https://flutter.dev', description: ''),
        ]),
        AppStrings.en,
      );
      expect(out, contains('[https://flutter.dev](https://flutter.dev)'));
    });

    test('description is included when provided', () {
      final out = gen.generate(
        _config(documentationReferences: [
          DocumentationReference(title: 'T', url: 'https://example.com', description: 'Official source'),
        ]),
        AppStrings.en,
      );
      expect(out, contains('Official source'));
    });

    test('description is omitted when empty', () {
      final out = gen.generate(
        _config(documentationReferences: [
          DocumentationReference(title: 'T', url: 'https://example.com', description: ''),
        ]),
        AppStrings.en,
      );
      final lines = out.split('\n');
      final h3 = lines.indexWhere((l) => l == '### T');
      final nextContent = lines.skip(h3 + 1).firstWhere((l) => l.isNotEmpty);
      expect(nextContent, startsWith('[https://example.com]'));
    });
  });

  group('localisation of headings', () {
    final fullConfig = _config(
      description: 'desc',
      techStack: [const TechStackEntry(category: 'C', technology: 'T')],
      setupCommands: [const SetupCommand(command: 'cmd')],
      coreFeatures: ['feat'],
      acceptanceCriteria: ['crit'],
      whatNotToDo: ['no'],
      documentationReferences: [
        DocumentationReference(title: 'D', url: 'https://x.com', description: ''),
      ],
    );

    test('EN headings', () {
      final out = gen.generate(fullConfig, AppStrings.en);
      expect(out, contains('## Project Overview'));
      expect(out, contains('## Tech Stack'));
      expect(out, contains('## Setup Commands'));
      expect(out, contains('## Core Features'));
      expect(out, contains('## Acceptance Criteria'));
      expect(out, contains('## What Not To Do'));
      expect(out, contains('## Documentation References'));
    });

    test('PT-BR headings', () {
      final out = gen.generate(fullConfig, AppStrings.ptBR);
      expect(out, contains('## Visão Geral do Projeto'));
      expect(out, contains('## Tech Stack'));
      expect(out, contains('## Comandos de Setup'));
      expect(out, contains('## Funcionalidades Principais'));
      expect(out, contains('## Critérios de Aceite'));
      expect(out, contains('## O Que Não Fazer'));
      expect(out, contains('## Documentações de Referência'));
    });
  });
}
