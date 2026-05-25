class TechStackEntry {
  final String category;
  final String technology;
  final String versionOrNotes;

  const TechStackEntry({
    required this.category,
    required this.technology,
    this.versionOrNotes = '',
  });
}
