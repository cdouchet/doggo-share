import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/services/link_storage_service.dart';
import 'package:mobile/theme/colors.dart';
import 'package:mobile/views/file_preview.dart';
import 'package:provider/provider.dart';

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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FilePreview(file: link)));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: DoggoColors.secondary, width: 4),
      ),
      title: Text(link.name),
      leading: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: DoggoColors.darkSecondary,
            borderRadius: BorderRadius.circular(12)),
        height: 45,
        width: 45,
        child: _getMime() == "image"
            ? CachedNetworkImage(
                imageUrl: link.url,
                errorWidget: (context, url, error) => Text(
                    link.name.split('.').last.toUpperCase(),
                    style: const TextStyle(color: Colors.white)),
                fit: BoxFit.cover,
              )
            : Text(
                _getMime(),
                style: const TextStyle(color: Colors.white),
              ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.remove, color: DoggoColors.secondary),
        onPressed: () {
          Provider.of<StoredLinkProvider>(context, listen: false)
              .removeLink(link);
          LinkStorageService().deleteLink(link);
        },
      ),
    );
  }
}
