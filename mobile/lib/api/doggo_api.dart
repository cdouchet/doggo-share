import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:mobile/models/error/doggo_error.dart';
import 'package:mobile/models/request/doggo_multipart.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/models/response/doggo_response.dart';
import 'package:result_type/result_type.dart';

class DoggoApi {
  static final baseUrl = dotenv.env["API_BASE_URL"]!;

  static Future<Result<DoggoResponse<DoggoFile>, DoggoError>> uploadFile(
      DoggoMultipart multi) async {
    final multipart = multi.toMultipartRequest();
    final response = await Response.fromStream(await multipart.send());
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
