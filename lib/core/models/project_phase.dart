class ProjectPhase {
  final String name;
  final String description;
  final List<String> tasks;

  const ProjectPhase({
    this.name = '',
    this.description = '',
    this.tasks = const [],
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'tasks': tasks,
      };

  factory ProjectPhase.fromJson(Map<String, dynamic> json) => ProjectPhase(
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        tasks: (json['tasks'] as List?)?.cast<String>() ?? const [],
      );
}
