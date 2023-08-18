// import 'package:dio/dio.dart';
// import 'package:path/path.dart' as path;
// import 'directory_path.dart';

// Future<double> startDownload({required String url}) async {
//   print('start1');

//   double progress = 0;
//   CancelToken cancelToken = CancelToken();
//   var storePath = await DirectoryPath().getPath();
//   String fileName = path.basename(url);
//   String filePath = '$storePath/$fileName';
//   print(filePath);
//   try {
//     await Dio().download(
//       url,
//       filePath,
//       onReceiveProgress: (count, total) {
//         progress = (count / total);
//       },
//       cancelToken: cancelToken,
//     );
//   } catch (e) {
//     print('catch true: $e');
//   }

//   return progress;
// }
