import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveClient {
  Future<Box> openBox(String boxName) async {
    if (!kIsWeb && !Hive.isBoxOpen(boxName)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }

    return await Hive.openBox(boxName);
  }
}
