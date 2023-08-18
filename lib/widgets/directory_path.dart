import 'package:path_provider/path_provider.dart';

class DirectoryPath {
  getPath() async {
    final path = await getExternalStorageDirectory();
    //final path = await getApplicationDocumentsDirectory();
    if (await path!.exists()) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }
}
