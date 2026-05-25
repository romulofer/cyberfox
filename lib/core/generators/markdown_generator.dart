import '../models/project_config.dart';
import '../templates/base_template.dart';

class MarkdownGenerator {
  String generate(ProjectConfig config) => buildProjectTemplate(config);
}
