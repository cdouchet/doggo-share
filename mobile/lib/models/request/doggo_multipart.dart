import 'dart:io';
import 'package:http/http.dart';
import 'package:mobile/api/doggo_api.dart';

class DoggoMultipart {
  final String name;
  final File file;

  DoggoMultipart({
    required this.name,
    required this.file
  });

  MultipartRequest toMultipartRequest() {
    MultipartRequest request = MultipartRequest("POST", Uri.parse("${DoggoApi.baseUrl}/files"));
    request.files.add(MultipartFile.fromBytes("file", file.readAsBytesSync()));
    request.fields.addAll({"name": name});
    return request;
  }
}