import 'package:flutter/material.dart';
import 'package:mobile/api/doggo_api.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/views/file_preview.dart';
import 'package:uni_links/uni_links.dart';

class UniversalLinksHelper {
  Future<DoggoFile?> useInitialLink() async {
    final initialLink = await getInitialLink();
    if (initialLink == null) {
      return null;
    }
    if (initialLink.contains("/f/")) {
      final id = initialLink.split("/f/")[1].split('/')[0];
      final file = await DoggoApi.getFileInfo(id);
      if (file.isFailure) {
        print(file.failure);
        return null;
      }
      return file.success.data;
    }
    return null;
  }

  void handleUniversalLinkCall(BuildContext context) {
    linkStream.listen((event) async {
      if (event != null) {
        if (event.contains("/f/")) {
          final id = event.split("/f/")[1].split('/')[0];
          DoggoApi.getFileInfo(id).then((file) {
            if (file.isFailure) {
              print(file.failure);
              return;
            }
            final f = file.success.data;
            f.saveToStorage(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FilePreview(file: f)));
          });
        }
      }
    });
  }
}
