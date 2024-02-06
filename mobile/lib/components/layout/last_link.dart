import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/services/link_storage_service.dart';
import 'package:mobile/theme/colors.dart';
import 'package:mobile/views/file_preview.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class LastLink extends StatelessWidget {
  final DoggoFile link;
  const LastLink({super.key, required this.link});
  String _getMime() {
    if (link.name.toLowerCase().endsWith(".png") ||
        link.name.toLowerCase().endsWith(".jpg") ||
        link.name.toLowerCase().endsWith(".jpeg") ||
        link.name.toLowerCase().endsWith(".bmp") ||
        link.name.toLowerCase().endsWith(".ico") ||
        link.name.toLowerCase().endsWith(".webp") ||
        link.name.toLowerCase().endsWith(".gif")) {
      return "image";
    }
    final splitted = link.name.split('.');
    if (splitted.last.length > 5) {
      return "FILE";
    }
    return splitted.last.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (kIsWeb) {
          html.window.open(link.url, "new tab");
          return;
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FilePreview(file: link)));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: DoggoColors.secondary, width: 4),
      ),
      title: Text(link.name, overflow: TextOverflow.ellipsis,),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: DoggoColors.darkSecondary,
              borderRadius: BorderRadius.circular(12),
              image: _getMime() == "image"
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(link.url))
                  : null),
          height: 45,
          width: 45,
          child: _getMime() == "image"
              ? Container()
              : Text(
                  _getMime(),
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: DoggoColors.secondary),
        onPressed: () {
          Provider.of<StoredLinkProvider>(context, listen: false)
              .removeLink(link);
          LinkStorageService().deleteLink(link);
        },
      ),
    );
  }
}
