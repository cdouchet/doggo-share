import 'package:flutter/material.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:mobile/services/link_storage_service.dart';

class StoredLinkProvider extends ChangeNotifier {
  List<DoggoFile> _storedLinks = [];
  List<DoggoFile> get storedLinks => _storedLinks;

  final storage = LinkStorageService();

  void setLinks() async {
    final l = await storage.getAllLinksUnchecked();
    _storedLinks = l.toList();
    notifyListeners();
  }

  void addLink(DoggoFile link) {
    if (!_storedLinks.any((e) => e.id == link.id)) {
      _storedLinks.add(link);
    }
    notifyListeners();
  }

  void addMultipleLinks(Iterable<DoggoFile> link) {
    _storedLinks.addAll(link);
    for (final l in link) {
      if (!_storedLinks.any((e) => e.id == l.id)) {
        _storedLinks.add(l);
      }
    }
    notifyListeners();
  }

  void removeLink(DoggoFile link) {
    if (_storedLinks.any((e) => e.id == link.id)) {
      _storedLinks.remove(link);
      notifyListeners();
    }
  }
}
