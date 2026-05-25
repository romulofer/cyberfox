class AiTarget {
  final String name;
  final String filename;

  const AiTarget({required this.name, required this.filename});
}

const List<AiTarget> aiTargets = [
  AiTarget(name: 'Claude Code', filename: 'CLAUDE.md'),
  AiTarget(name: 'Cursor', filename: '.cursorrules'),
  AiTarget(name: 'Windsurf', filename: '.windsurfrules'),
  AiTarget(name: 'Cline', filename: '.clinerules'),
  AiTarget(name: 'GitHub Copilot', filename: 'copilot-instructions.md'),
  AiTarget(name: 'Aider', filename: 'CONVENTIONS.md'),
  AiTarget(name: 'Devin', filename: 'AGENTS.md'),
];
