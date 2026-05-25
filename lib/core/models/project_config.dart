import 'ai_target.dart';
import 'documentation_reference.dart';
import 'setup_command.dart';
import 'tech_stack_entry.dart';

class ProjectConfig {
  final String projectName;
  final String description;
  final AiTarget targetAi;
  final List<TechStackEntry> techStack;
  final List<SetupCommand> setupCommands;
  final List<String> coreFeatures;
  final List<String> acceptanceCriteria;
  final List<String> whatNotToDo;
  final List<DocumentationReference> documentationReferences;

  ProjectConfig({
    required this.projectName,
    required this.description,
    required this.targetAi,
    this.techStack = const [],
    this.setupCommands = const [],
    this.coreFeatures = const [],
    this.acceptanceCriteria = const [],
    this.whatNotToDo = const [],
    this.documentationReferences = const [],
  });
}
