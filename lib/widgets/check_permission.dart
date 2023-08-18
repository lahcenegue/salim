import 'package:dinetemp/main.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissions() async {
  bool permission = false;
  PermissionStatus isStorage = await Permission.storage.status;
  PermissionStatus isAccesLc = await Permission.accessMediaLocation.status;
  // PermissionStatus isMangEx = await Permission.manageExternalStorage.status;

  if (!isStorage.isGranted) {
    await Permission.storage.request();
  } else if (!isAccesLc.isGranted) {
    await Permission.accessMediaLocation.request();
  }
  // else if (!isMangEx.isGranted) {
  //   await Permission.manageExternalStorage.request();
  // }
  else {
    permission = true;
  }

  isPermission = permission;
  return permission;
}

// class CheckPermission {
//   Future<bool> isStoragePermission() async {
//     PermissionStatus isStorage = await Permission.storage.status;
//     PermissionStatus isAccesLc = await Permission.accessMediaLocation.status;
//     PermissionStatus isMangEx = await Permission.manageExternalStorage.status;
//     if (!isMangEx.isGranted || !isAccesLc.isGranted || !isStorage.isGranted) {
//       await Permission.storage.request();
//       await Permission.accessMediaLocation.request();
//       await Permission.manageExternalStorage.request();

//       if (!isMangEx.isGranted || !isAccesLc.isGranted || !isStorage.isGranted) {
//         return false;
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//   }
// }
