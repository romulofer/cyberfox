class SetupCommand {
  final String command;
  final String description;

  const SetupCommand({
    required this.command,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'command': command,
        'description': description,
      };

  factory SetupCommand.fromJson(Map<String, dynamic> json) => SetupCommand(
        command: json['command'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );
}
