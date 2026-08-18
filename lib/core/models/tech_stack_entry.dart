class TechStackEntry {
  final String category;
  final String technology;
  final String versionOrNotes;

  const TechStackEntry({
    required this.category,
    required this.technology,
    this.versionOrNotes = '',
  });

  Map<String, dynamic> toJson() => {
        'category': category,
        'technology': technology,
        'versionOrNotes': versionOrNotes,
      };

  factory TechStackEntry.fromJson(Map<String, dynamic> json) => TechStackEntry(
        category: json['category'] as String? ?? '',
        technology: json['technology'] as String? ?? '',
        versionOrNotes: json['versionOrNotes'] as String? ?? '',
      );
}
