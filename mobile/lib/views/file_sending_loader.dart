import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/api/doggo_api.dart';
import 'package:mobile/models/request/doggo_multipart.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/services/link_storage_service.dart';
import 'package:mobile/theme/colors.dart';
import 'package:mobile/views/success_file.dart';
import 'package:provider/provider.dart';

class FileSendingLoader extends StatefulWidget {
  final PlatformFile file;
  const FileSendingLoader({super.key, required this.file});

  @override
  State<FileSendingLoader> createState() => _FileSendingLoaderState();
}

class _FileSendingLoaderState extends State<FileSendingLoader> {
  double _progress = 0.0;
  bool? _isSuccess;

  @override
  void initState() {
    super.initState();
    _sendFile();
  }

  void _sendFile() {
    setState(() {
      _isSuccess = null;
    });
    DoggoApi.uploadFile(
        DoggoMultipart(name: widget.file.name, file: widget.file), (progress) {
      print("Progress: $progress");
      setState(() {
        _progress = progress;
      });
    }).then((result) {
      if (result.isFailure) {
        setState(() {
          _isSuccess = false;
        });
        return;
      }
      setState(() {
        _isSuccess = true;
      });
      LinkStorageService().storeLink(result.success.data);
      Provider.of<StoredLinkProvider>(context, listen: false)
          .addLink(result.success.data);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SuccessFile(
                    file: result.success.data,
                  )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
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
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSuccess == null) ...[
                  Text("Envoi de ${widget.file.name}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(
                    height: 30,
                  ),
                  CircularProgressIndicator(
                      value: _progress, color: DoggoColors.secondary),
                  const SizedBox(height: 15),
                  Text("${(_progress * 100).round()} %", style: const TextStyle(fontSize: 24))
                ] else if (_isSuccess == false) ...[
                  const Text("Une erreur est survenue",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28)),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ElevatedButton(
                      onPressed: () {
                        _sendFile();
                      },
                      style: ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                        ),
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return DoggoColors.darkSecondary;
                          }
                          return DoggoColors.secondary;
                        }),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        padding: const MaterialStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.backup, color: Colors.white),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Réessayer",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ));
  }
}
