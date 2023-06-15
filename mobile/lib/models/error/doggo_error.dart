class DoggoError {
  final String name;
  final int statusCode;

  DoggoError({required this.name, required this.statusCode});

  factory DoggoError.fromJson(Map<String, dynamic> json) =>
      DoggoError(name: json["name"], statusCode: json["status_code"]);
}
