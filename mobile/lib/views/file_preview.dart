import 'package:cached_network_image/cached_network_image.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FilePreview extends StatefulWidget {
  final DoggoFile file;
  const FilePreview({super.key, required this.file});

  @override
  State<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: DoggoColors.secondary,
          onTap: (i) async {
            switch (i) {
              case 0:
                final taskId = FlutterDownloader.enqueue(
                        url: widget.file.url,
                        allowCellular: true,
                        fileName: widget.file.name,
                        openFileFromNotification: true,
                        requiresStorageNotLow: false,
                        savedDir:
                            (await getApplicationDocumentsDirectory()).path)
                    .catchError((err, st) {
                  print("Something went wrong when downloading file");
                  print("Err: $err");
                  print("Stacktrace: $st");
                }).then((value) {
                  print("value: $value");
                  FloatingSnackBar(
                      message: "${widget.file.name} a été téléchargé",
                      context: context,
                      backgroundColor: DoggoColors.secondary,
                      textColor: Colors.white,
                      duration: const Duration(seconds: 2));
                });
                break;
              case 1:
                Clipboard.setData(ClipboardData(text: widget.file.url))
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Lien copié !", gravity: ToastGravity.BOTTOM);
                });
                break;
              case 2:
                Share.share(widget.file.url);
                break;
              default:
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.download, color: Colors.white), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy, color: Colors.white), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.ios_share, color: Colors.white), label: ""),
          ]),
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        centerTitle: true,
        title: Text(widget.file.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w400)),
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: IconButton(
            iconSize: 36,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: DoggoColors.secondary),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: _handleFileType()),
        ],
      )),
    );
  }

  bool _isImage() {
    return ["png", "jpg", "jpeg", "bmp", "ico", "webp", "gif"]
        .contains(widget.file.name.split('.').last.toLowerCase());
  }

  bool _isPDF() {
    return widget.file.name.split('.').last.toLowerCase() == "pdf";
  }

  Widget _noPreview() => Center(
      child: Container(
          alignment: Alignment.center,
          child: Text("No preview for ${widget.file.name}")));

  Widget _handleFileType() {
    if (_isImage()) {
      return CachedNetworkImage(
        imageUrl: widget.file.url,
        errorWidget: (_, __, ___) => Center(child: _noPreview()),
      );
    }
    if (_isPDF()) {
      return PDFView(
        filePath: widget.file.url,
        enableSwipe: true,
        autoSpacing: true,
      );
    }
    return _noPreview();
  }
}
