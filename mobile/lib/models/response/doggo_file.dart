class DoggoFile {
  final String createdAt;
  final String updatedAt;
  final String id;
  final String url;
  final String name;

  DoggoFile(
      {required this.createdAt,
      required this.updatedAt,
      required this.id,
      required this.url,
      required this.name});

  factory DoggoFile.fromJson(Map<String, dynamic> json) => DoggoFile(
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      id: json["id"],
      url: json["net_url"],
      name: json["name"]);
}
