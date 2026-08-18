class DocumentationReference {
  final String title;
  final String url;
  final String description;

  DocumentationReference({
    required this.title,
    required this.url,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
        'description': description,
      };

  factory DocumentationReference.fromJson(Map<String, dynamic> json) =>
      DocumentationReference(
        title: json['title'] as String? ?? '',
        url: json['url'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );
}
