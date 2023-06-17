import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/theme/colors.dart';
import 'package:mobile/views/file_sending_loader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as bs;

class CreateDoggoFileView extends StatefulWidget {
  const CreateDoggoFileView({super.key});

  @override
  State<CreateDoggoFileView> createState() => _CreateDoggoFileViewState();
}

class _CreateDoggoFileViewState extends State<CreateDoggoFileView> {
  PlatformFile? _selectedFile;

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
                    : _selectedFile!.path!.split('/').last,
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

  Widget _bottomModalItem(IconData icon, String title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Icon(icon, color: DoggoColors.secondary),
        Text(title, style: const TextStyle(fontSize: 22))],
      ),
    );
  }

  _showDoggoDialog() {
    bs.showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              color: Colors.transparent,
              padding: const EdgeInsets.all(18),
              child: const Column());
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
