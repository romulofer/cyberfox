import '../models/project_config.dart';

String buildProjectTemplate(ProjectConfig config) {
  final b = StringBuffer();

  // Project Overview
  b.writeln('# ${config.projectName}');
  b.writeln();
  b.writeln('## Project Overview');
  b.writeln();
  if (config.description.isNotEmpty) b.writeln(config.description);

  // Tech Stack
  if (config.techStack.isNotEmpty) {
    b.writeln();
    b.writeln('## Tech Stack');
    b.writeln();
    b.writeln('| Category | Technology | Version / Notes |');
    b.writeln('|----------|------------|-----------------|');
    for (final e in config.techStack) {
      b.writeln('| ${e.category} | ${e.technology} | ${e.versionOrNotes} |');
    }
  }

  // Setup Commands
  if (config.setupCommands.isNotEmpty) {
    b.writeln();
    b.writeln('## Setup Commands');
    b.writeln();
    b.writeln('```bash');
    for (int i = 0; i < config.setupCommands.length; i++) {
      final cmd = config.setupCommands[i];
      if (cmd.description.isNotEmpty) b.writeln('# ${cmd.description}');
      final isLast = i == config.setupCommands.length - 1;
      if (isLast) {
        b.write(cmd.command);
      } else {
        b.writeln('${cmd.command}\n');
      }
    }
    b.writeln();
    b.write('```');
  }

  // Core Features
  if (config.coreFeatures.isNotEmpty) {
    b.writeln();
    b.writeln();
    b.writeln('## Core Features');
    b.writeln();
    for (final f in config.coreFeatures) {
      b.writeln('- $f');
    }
  }

  // Acceptance Criteria
  if (config.acceptanceCriteria.isNotEmpty) {
    b.writeln();
    b.writeln('## Acceptance Criteria');
    b.writeln();
    for (final c in config.acceptanceCriteria) {
      b.writeln('- $c');
    }
  }

  // What Not To Do
  if (config.whatNotToDo.isNotEmpty) {
    b.writeln();
    b.writeln('## What Not To Do');
    b.writeln();
    for (final w in config.whatNotToDo) {
      b.writeln('- $w');
    }
  }

  // Documentation References
  if (config.documentationReferences.isNotEmpty) {
    b.writeln();
    b.writeln('## Documentation References');
    b.writeln();
    for (final ref in config.documentationReferences) {
      b.writeln('### ${ref.title}');
      b.writeln();
      if (ref.description.isNotEmpty) {
        b.writeln(ref.description);
        b.writeln();
      }
      b.writeln('[${ref.url}](${ref.url})');
      b.writeln();
    }
  }

  return b.toString().trimRight();
}
