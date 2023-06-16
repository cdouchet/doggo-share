import 'package:flutter/material.dart';
import 'package:mobile/components/layout/last_link.dart';
import 'package:mobile/components/layout/stored_link_search.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/theme/colors.dart';
import 'package:provider/provider.dart';

class AllStoredLinksView extends StatefulWidget {
  const AllStoredLinksView({super.key});

  @override
  State<AllStoredLinksView> createState() => _AllStoredLinksViewState();
}

class _AllStoredLinksViewState extends State<AllStoredLinksView> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoredLinkProvider>(context);
    final sorted = provider.storedLinks.where((element) => element.name
        .trim()
        .toLowerCase()
        .replaceAll(' ', "")
        .startsWith(textEditingController.text
            .trim()
            .toLowerCase()
            .replaceAll(' ', "")));
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Liens récents",
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                StoredLinkSearch(controller: textEditingController, setState: setState),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        final item = sorted.elementAt(index);
                        return LastLink(link: item);
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemCount: sorted.length),
                )
              ],
            ),
          )),
        ));
  }
}
