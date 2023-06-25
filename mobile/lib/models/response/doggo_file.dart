import 'package:flutter/material.dart';
import 'package:mobile/providers/stored_links_providers.dart';
import 'package:mobile/services/link_storage_service.dart';
import 'package:provider/provider.dart';

class DoggoFile {
  final String createdAt;
  final String updatedAt;
  final String id;
  final String url;
  final String name;

  DoggoFile(
      {required this.createdAt,
      required this.updatedAt,
      required this.id,
      required this.url,
      required this.name});

  factory DoggoFile.fromJson(Map<String, dynamic> json) => DoggoFile(
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      id: json["id"],
      url: json["net_url"],
      name: json["name"]);

  Map<String, String> toJson() => {
        "created_at": createdAt,
        "updated_at": updatedAt,
        "id": id,
        "net_url": url,
        "name": name
      };

  void saveToStorage(BuildContext context) {
    LinkStorageService().storeLink(this);
    Provider.of<StoredLinkProvider>(context, listen: false).addLink(this);
  }

  String get mimeType => name.split('.').last.toLowerCase();
}
