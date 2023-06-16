import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/components/layout/create_doggo_file.dart';
import 'package:mobile/components/layout/last_link.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/services/link_storage_service.dart';
import 'package:mobile/theme/colors.dart';
import 'package:mobile/utils/universal_links_helper.dart';
import 'package:mobile/utils/utils.dart';
import 'package:mobile/views/all_stored_links.dart';
import 'package:mobile/views/file_preview.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700));
  late Animation<Color?> animation =
      ColorTween(begin: DoggoColors.secondary, end: Colors.white)
          .animate(controller)
        ..addListener(() {
          setState(() {
            barColor = animation.value!;
          });
        });
  Color barColor = DoggoColors.secondary;
  late double _introWidth = MediaQuery.of(context).size.width;
  late double _introHeight = MediaQuery.of(context).size.height;
  LinkStorageService linkStorageService = LinkStorageService();
  bool _hasLoadedStoredLinks = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: DoggoColors.secondary,
      systemNavigationBarColor: DoggoColors.secondary,
    ));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _hasLoadedStoredLinks = true;
      });
      Provider.of<StoredLinkProvider>(context, listen: false).setLinks();
      Future.delayed(const Duration(seconds: 2), () {
        controller.reset();
        controller.forward();
        setState(() {
          _introWidth = 0;
          _introHeight = 0;
        });
      }).then((value) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white));
      });
      final ulh = UniversalLinksHelper();
      ulh.handleUniversalLinkCall(context);
      ulh.useInitialLink().then((possibleFile) {
        if (possibleFile != null) {
          possibleFile.saveToStorage(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FilePreview(file: possibleFile)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Colors.white,
            toolbarHeight: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarColor: DoggoColors.secondary,
                systemNavigationBarColor: DoggoColors.secondary)),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  constraints: const BoxConstraints.expand(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: double.maxFinite,
                          height: 200,
                          child: Image.asset(
                              "assets/images/logo-transparent.png",
                              fit: BoxFit.cover)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                            "Doggo Share vous permet d'envoyer des fichiers sans limite de taille et à grande vitesse.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 18),
                                  child: CreateDoggoFileButton()))
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Vos derniers liens",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllStoredLinksView()));
                                },
                                child: const Text("Tout voir",
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: DoggoColors.secondary)))
                          ],
                        ),
                      ),
                      if (!_hasLoadedStoredLinks)
                        Container(
                            width: double.maxFinite,
                            height: 300,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator.adaptive())
                      else
                        Flexible(
                          child: FutureBuilder(
                              future: linkStorageService.getAllLinks(),
                              builder: (context, snapshot) {
                                Iterable<DoggoFile> links = [];
                                if (snapshot.hasData) {
                                  final data = snapshot.data!;
                                  if (data.isFailure) {
                                    print(data.failure);
                                    return const Text("error reading storage");
                                  }
                                  links = Utils.takeLastThree(
                                      Provider.of<StoredLinkProvider>(context,
                                              listen: true)
                                          .storedLinks);
                                }
                                return Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.all(18),
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return LastLink(
                                            link: links.elementAt(index));
                                      },
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemCount: links.length),
                                );
                              }),
                        )
                    ],
                  )),
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.fastOutSlowIn,
                    width: _introWidth,
                    height: _introHeight,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/logo-transparent.png"),
                          Text("Doggo Share",
                              style: TextStyle(
                                  color: _introHeight == 0
                                      ? Colors.transparent
                                      : Colors.white,
                                  fontSize: 22))
                        ])),
              )
            ],
          ),
        ));
  }
}
