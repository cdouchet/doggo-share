import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/error/doggo_error.dart';
import 'package:mobile/models/request/doggo_multipart.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/models/response/doggo_response.dart';
import 'package:result_type/result_type.dart';

import '../utils/multipart_request.dart';

class DoggoApi {
  static final baseUrl = dotenv.env["API_BASE_URL"]!;

  static Future<Result<DoggoResponse<DoggoFile>, DoggoError>> getFileInfo(
      String id) async {
        print("IDDDDDD: $id");
    final response = await http.get(Uri.parse("$baseUrl/file/info/$id"));
    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return Success(DoggoResponse(
          data: DoggoFile.fromJson(decoded["data"]),
          description: decoded["description"]));
    }
    return Failure(DoggoError.fromJson(decoded));
  }

  static Future<Result<DoggoResponse<DoggoFile>, DoggoError>> uploadFile(
      DoggoMultipart multi, Function(double progress) progress) async {
    MultipartRequest request =
        MultipartRequest("POST", Uri.parse("${DoggoApi.baseUrl}/files"),
            onProgress: (bytes, total) {
      progress(bytes / total);
    });
    request.files.add(http.MultipartFile.fromBytes("file", multi.file.bytes!));
    request.fields.addAll({"name": multi.name});
    final response = await http.Response.fromStream(await request.send());
    final decoded = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final dr = DoggoResponse(
          description: decoded["description"],
          data: DoggoFile.fromJson(decoded["data"]));
      return Success(dr);
    }
    return Failure(DoggoError.fromJson(decoded));
  }
}
