import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/views/login.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const DoggoShare());
}

class DoggoShare extends StatelessWidget {
  const DoggoShare({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: Login()
    );
  }
}