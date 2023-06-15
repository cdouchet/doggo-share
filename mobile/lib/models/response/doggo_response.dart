class DoggoResponse<T> {
  final String description;
  final T data;

  DoggoResponse({
    required this.description,
    required this.data
  });
}