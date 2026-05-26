import '../l10n/app_strings.dart';
import '../models/project_config.dart';
import '../templates/base_template.dart';

class MarkdownGenerator {
  String generate(ProjectConfig config, AppStrings strings) =>
      buildProjectTemplate(config, strings);
}
