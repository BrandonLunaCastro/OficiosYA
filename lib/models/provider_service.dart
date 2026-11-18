class ProviderService {
  final String id;
  final String title;
  final String description;

  const ProviderService({
    required this.id,
    required this.title,
    required this.description,
  });

  ProviderService copyWith({String? title, String? description}) {
    return ProviderService(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
