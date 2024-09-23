import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fishing_helper/constants/api_constants.dart';

class StorageApi {
  Reference storage = FirebaseStorage.instance.ref();

  Stream<TaskSnapshot> uploadFileStream(String journeyId, String path) {
    File file = File(path);
    return storage
        .child('$journeyId/${ApiConstants.journeyFiles}')
        .putFile(file)
        .snapshotEvents;
  }

// Stream<TaskSnapshot> downloadFile() {
//   return
// }
}
