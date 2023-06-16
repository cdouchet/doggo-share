import 'package:flutter/material.dart';
import 'package:mobile/theme/colors.dart';
import 'package:mobile/views/create_file_view.dart';

class CreateDoggoFileButton extends StatelessWidget {
  const CreateDoggoFileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateDoggoFileView()));
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
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 18, horizontal: 18))
        ),
        child: const Text("Envoyer un fichier", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)));
  }
}
