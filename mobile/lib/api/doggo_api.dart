import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/error/doggo_error.dart';
import 'package:mobile/models/request/doggo_multipart.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/models/response/doggo_response.dart';
import 'package:result_type/result_type.dart';

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
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 30);
    final request = await httpClient.postUrl(Uri.parse("$baseUrl/files"));
    int byteCount = 0;
    http.MultipartFile multipart =
        await http.MultipartFile.fromPath("file", multi.file.path!);
    http.MultipartRequest requestMultipart =
        http.MultipartRequest("POST", Uri.parse("$baseUrl/files"));
    requestMultipart.fields.addAll({"name": multi.file.name});
    requestMultipart.files.add(multipart);
    http.ByteStream fileStream = requestMultipart.finalize();
    // final fileStream = file.openRead();
    final totalByteLength = requestMultipart.contentLength;
    // final mimeType = lookupMimeType(file.path)!;
    // request.headers.add("Content-Type", mimeType);
    request.contentLength = totalByteLength;
    request.headers.set(HttpHeaders.contentTypeHeader,
        requestMultipart.headers[HttpHeaders.contentTypeHeader]!);

    Stream<List<int>> streamUpload =
        fileStream.transform(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data);
        byteCount += data.length;
        progress(byteCount / totalByteLength);
      },
      handleError: (error, stack, sink) {
        print(error.toString());
      },
      handleDone: (sink) {
        sink.close();
        // UPLOAD DONE;
      },
    ));
    await request.addStream(streamUpload);
    final response = await request.close();
    final body = await readResponse(response);
    final decoded = jsonDecode(body);
    if (response.statusCode == 200) {
      final dr = DoggoResponse(
          description: decoded["description"],
          data: DoggoFile.fromJson(decoded["data"]));
      return Success(dr);
    }
    return Failure(DoggoError.fromJson(decoded));
  }

  static Future<String> readResponse(HttpClientResponse response) {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  // static Future<Result<DoggoResponse<DoggoFile>, DoggoError>> uploadFile(
  //     DoggoMultipart multi, Function(double progress) progress) async {
  //   http.MultipartRequest request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse("${DoggoApi.baseUrl}/files"),
  //   );
  //   request.files.add(http.MultipartFile.fromBytes("file", multi.file.bytes!));
  //   request.fields.addAll({"name": multi.name});
  //   http.ByteStream msStream = request.finalize();
  //   final totalByteLength = request.contentLength;
  //   request.contentLength = totalByteLength;
  //   final response = await http.Response.fromStream(await request.send());
  //   final decoded = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     final dr = DoggoResponse(
  //         description: decoded["description"],
  //         data: DoggoFile.fromJson(decoded["data"]));
  //     return Success(dr);
  //   }
  //   return Failure(DoggoError.fromJson(decoded));
  // }
}
