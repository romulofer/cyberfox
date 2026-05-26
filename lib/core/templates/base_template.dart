import '../l10n/app_strings.dart';
import '../models/project_config.dart';

String buildProjectTemplate(ProjectConfig config, AppStrings s) {
  final b = StringBuffer();

  b.writeln('# ${config.projectName}');
  b.writeln();
  b.writeln('## ${s.mdProjectOverview}');
  b.writeln();
  if (config.description.isNotEmpty) b.writeln(config.description);

  if (config.techStack.isNotEmpty) {
    b.writeln();
    b.writeln('## ${s.mdTechStack}');
    b.writeln();
    b.writeln('| ${s.mdTechCategory} | ${s.mdTechTechnology} | ${s.mdTechVersionNotes} |');
    b.writeln('|----------|------------|-----------------|');
    for (final e in config.techStack) {
      b.writeln('| ${e.category} | ${e.technology} | ${e.versionOrNotes} |');
    }
  }

  if (config.setupCommands.isNotEmpty) {
    b.writeln();
    b.writeln('## ${s.mdSetupCommands}');
    b.writeln();
    b.writeln('| ${s.mdSetupCommand} | ${s.mdSetupDescription} |');
    b.writeln('|---------|-------------|');
    for (final cmd in config.setupCommands) {
      b.writeln('| `${cmd.command}` | ${cmd.description} |');
    }
  }

  if (config.coreFeatures.isNotEmpty) {
    b.writeln();
    b.writeln();
    b.writeln('## ${s.mdCoreFeatures}');
    b.writeln();
    for (final f in config.coreFeatures) {
      b.writeln('- $f');
    }
  }

  if (config.acceptanceCriteria.isNotEmpty) {
    b.writeln();
    b.writeln('## ${s.mdAcceptanceCriteria}');
    b.writeln();
    for (final c in config.acceptanceCriteria) {
      b.writeln('- $c');
    }
  }

  if (config.whatNotToDo.isNotEmpty) {
    b.writeln();
    b.writeln('## ${s.mdWhatNotToDo}');
    b.writeln();
    for (final w in config.whatNotToDo) {
      b.writeln('- $w');
    }
  }

  if (config.documentationReferences.isNotEmpty) {
    b.writeln();
    b.writeln('## ${s.mdDocumentationReferences}');
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
