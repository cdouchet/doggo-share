import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/views/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  runApp(const DoggoShare());
}

class DoggoShare extends StatelessWidget {
  const DoggoShare({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StoredLinkProvider>(
            create: (context) => StoredLinkProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DefaultTextStyle.merge(
              child: const Home(),
              style: GoogleFonts.rubik(
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)))),
    );
  }
}
