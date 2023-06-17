import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/theme/colors.dart';
import 'package:mobile/views/file_sending_loader.dart';
import 'package:image_picker/image_picker.dart';

class CreateDoggoFileView extends StatefulWidget {
  const CreateDoggoFileView({super.key});

  @override
  State<CreateDoggoFileView> createState() => _CreateDoggoFileViewState();
}

class _CreateDoggoFileViewState extends State<CreateDoggoFileView> {
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        centerTitle: true,
        title: const Text("Envoyer un fichier",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 70,
            // ),
            const Spacer(),
            Text(
                _selectedFile == null
                    ? "Sélectionnez un fichier"
                    : _selectedFile!.path.split('/').last,
                style: const TextStyle(fontSize: 28)),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                onPressed: () {
                  _showDoggoDialog();
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
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
                    Icon(Icons.file_copy, color: Colors.white),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sélectionner un fichier",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedFile == null) {
                    return;
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FileSendingLoader(file: _selectedFile!)));
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  elevation: const MaterialStatePropertyAll(0),
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (_selectedFile == null) {
                      return Colors.grey;
                    }
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
                    Text(
                      "Envoyer",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.send, color: Colors.white)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _handleIOS(int index) {
    final ImagePicker picker = ImagePicker();
    switch (index) {
      case 0:
        picker.pickImage(source: ImageSource.gallery).then((value) {
          if (value != null) {
            setState(() {
              _selectedFile = File(value.path);
            });
          }
        });
        break;
      case 1:
        picker.pickImage(source: ImageSource.camera).then((value) {
          if (value != null) {
            setState(() {
              _selectedFile = File(value.path);
            });
          }
        });
        break;
      case 2:
        FilePicker.platform
            .pickFiles(
                allowCompression: false, allowMultiple: false, withData: true)
            .then((value) {
          if (value != null) {
            setState(() {
              _selectedFile = File(value.files.first.path!);
            });
          }
        });
    }
  }

  void _handleAndroid(int index) {
    final ImagePicker picker = ImagePicker();
    switch (index) {
      case 0:
        FilePicker.platform
            .pickFiles(
                allowCompression: false, allowMultiple: false, withData: true)
            .then((value) {
          if (value != null) {
            setState(() {
              _selectedFile = File(value.files.first.path!);
            });
          }
        });
        break;
      case 1:
        picker.pickImage(source: ImageSource.camera).then((value) {
          if (value != null) {
            _selectedFile = File(value.path);
          }
        });
    }
  }
  Widget _bottomModalItem(IconData icon, String title, int index) {
    return GestureDetector(
      onTap: () {
        if (Platform.isIOS) {
          _handleIOS(index);
          return;
        }
        _handleAndroid(index);
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.white),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: DoggoColors.secondary, size: 32),
            Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600), textDirection: TextDirection.rtl)
          ],
        ),
      ),
    );
  }

  _showDoggoDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(18),
              child: Wrap(
                children: [
                  Column(children: [
                    if (Platform.isIOS) ...[
                      _bottomModalItem(Icons.photo_library, "Choisir une image", 0),
                      const SizedBox(height: 10),
                      _bottomModalItem(Icons.camera_alt, "Prendre une photo", 1),
                      const SizedBox(height: 10),
                      _bottomModalItem(Icons.file_copy, "Choisir un fichier", 2),
                    ] else ...[
                      _bottomModalItem(Icons.file_copy, "Choisir un fichier", 0),
                      const SizedBox(height: 10),
                      _bottomModalItem(Icons.camera_alt, "Prendre une photo", 1),
                    ],
                    const SizedBox(height: 30,),
                  ]),
                ],
              ));
        });
    // FilePickerResult? result =
    //                   await FilePicker.platform.pickFiles(withData: true);
    //               if (result == null) {
    //                 return;
    //               }
    //               if (result.isSinglePick) {
    //                 setState(() {
    //                   _selectedFile = result.files.first;
    //                 });
    //               }
  }
}
