import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/models/response/doggo_file.dart';
import 'package:result_type/result_type.dart';

class StoredLink {
  final String id;
  final String url;

  StoredLink({required this.id, required this.url});

  factory StoredLink.fromJson(Map<String, dynamic> json) =>
      StoredLink(id: json["id"], url: json["url"]);

  Map<String, String> toJson() => {"id": id, "url": url};
}

class LinkStorageService {
  final fss = const FlutterSecureStorage();

  LinkStorageService() {
    _verifyLinksCreated();
  }

  _verifyLinksCreated() async {
    if (!(await fss.containsKey(key: "links"))) {
      await fss.write(key: "links", value: "[]");
    }
  }

  Future<Result<Iterable<DoggoFile>, String>> getAllLinks() async {
    return Success([
      DoggoFile(
          id: "1",
          url: "url",
          createdAt: "",
          name: "snapshot.png",
          updatedAt: ""),
      DoggoFile(
          id: "1",
          url: "url",
          createdAt: "",
          name: "snapshot.didi",
          updatedAt: ""),
      DoggoFile(
          id: "1",
          url: "url",
          createdAt: "",
          name: "snapshot.ydkedj",
          updatedAt: ""),
    ]);
    final c = await fss.read(key: "links");
    if (c == null) {
      return Failure("links was not set in storage");
    }
    final parsed = jsonDecode(c);
    return Success((parsed as List).map((e) => DoggoFile.fromJson(e)));
  }

  Future<Iterable<DoggoFile>> getAllLinksUnchecked() async {
    return (jsonDecode((await fss.read(key: "links"))!) as List)
        .map((e) => DoggoFile.fromJson(e));
  }

  Future<void> storeMultipleLinks(Iterable<DoggoFile> links) async {
    List<DoggoFile> l = (await getAllLinksUnchecked()).toList();
    l.addAll(links);
    fss.write(key: "links", value: jsonEncode(l.map((e) => e.toJson())));
  }

  Future<void> storeLink(DoggoFile link) async {
    List<DoggoFile> l = (await getAllLinksUnchecked()).toList();
    if (!l.any((e) => e.id == link.id)) {
      l.add(link);
      fss.write(
          key: "links", value: jsonEncode(l.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> deleteLink(DoggoFile link) async {
    List<DoggoFile> l = (await getAllLinksUnchecked()).toList();
    if (l.any((e) => e.id == link.id)) {
      l.removeWhere((e) => e.id == link.id);
      fss.write(
          key: "links", value: jsonEncode(l.map((e) => e.toJson()).toList()));
    }
  }

  Future<void> updateLink(String link) async {
    List<DoggoFile> l = (await getAllLinksUnchecked()).toList();
    if (!l.any((e) => e.url == link)) {
      print("No link in storage");
      return;
    }
    final found = l.firstWhere((e) => e.url == link);
    l.removeWhere((e) => e.url == link);
    l.add(found);
    fss.write(
        key: "links", value: jsonEncode(l.map((e) => e.toJson()).toList()));
  }
}
