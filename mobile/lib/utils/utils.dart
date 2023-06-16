import 'package:mobile/models/response/doggo_file.dart';

class Utils {
  static List<DoggoFile> takeLastThree(List<DoggoFile> list) {
  int length = list.length;
  if (length >= 3) {
    return list.sublist(length - 3);
  } else {
    return list;
  }
}
}