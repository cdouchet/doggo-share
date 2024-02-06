import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/views/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
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
        theme: ThemeData(fontFamily: "Rubik", useMaterial3: false),
          debugShowCheckedModeBanner: false,
          home: DefaultTextStyle.merge(
              child: const Home(),
              style: const TextStyle(fontFamily: "assets/fonts/Rubik-VariableFont_wght.ttf"))),
    );
  }
}
