import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/theme/colors.dart';
import 'package:share_plus/share_plus.dart';

class SuccessFile extends StatefulWidget {
  final DoggoFile file;
  const SuccessFile({super.key, required this.file});

  @override
  State<SuccessFile> createState() => _SuccessFileState();
}

class _SuccessFileState extends State<SuccessFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          centerTitle: true,
          title: const Text("Succès",
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
        body: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text("Votre lien pour ${widget.file.name} est prêt",
                textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28)),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.file.url))
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Lien copié !", gravity: ToastGravity.BOTTOM);
                      });
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
                        Icon(Icons.file_copy, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Copier le lien",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ElevatedButton(
                    onPressed: () {
                      Share.share(widget.file.url);
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
                        Icon(Icons.ios_share, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Partager",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                        Text(
                          "Terminer",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ));
  }
}
