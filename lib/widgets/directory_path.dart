import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryPath {
  getPath() async {
    final path = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    //final path = await getApplicationDocumentsDirectory();
    if (await path!.exists()) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }
}
