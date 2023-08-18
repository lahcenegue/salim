import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../data/sqldb.dart';
import '../main.dart';
import 'check_permission.dart';
import 'directory_path.dart';

class DownloadItem extends StatefulWidget {
  final String title;
  final String url;

  const DownloadItem({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<DownloadItem> createState() => _DownloadItemState();
}

class _DownloadItemState extends State<DownloadItem> {
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = '';
  late String filePath;
  late CancelToken cancelToken;

  Future<bool> addDownloadFavorite(
      {required String title, required String path}) async {
    bool isFavorite = false;
    int response = await SqlDb().insertData('''
                                     INSERT INTO download ("name", "path")
                                     VALUES ("$title", "$path")
                                      ''');

    if (response > 0) {
      isFavorite = true;
    }
    return isFavorite;
  }

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await DirectoryPath().getPath();
    filePath = '$storePath/$fileName';

    try {
      setState(() {
        dowloading = true;
      });

      await Dio().download(
        widget.url,
        filePath,
        onReceiveProgress: (count, total) {
          setState(() {
            progress = (count / total);
          });
        },
        cancelToken: cancelToken,
      ).then((value) {
        addDownloadFavorite(
          title: widget.title,
          path: filePath,
        ).then((value) {
          setState(() {
            dowloading = false;
            fileExists = true;
          });
        });
      });
    } catch (e) {
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await DirectoryPath().getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      fileName = path.basename(widget.url);
    });
    checkFileExit();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF1F0FD),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            offset: const Offset(3, 4),
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (!fileExists && dowloading) {
              cancelDownload();
            }
          },
          icon: fileExists && dowloading == false
              ? const Icon(
                  Icons.window,
                  color: Colors.green,
                )
              : const Icon(Icons.close),
        ),
        trailing: IconButton(
          onPressed: () {
            if (isPermission) {
              if (!fileExists) {
                startDownload();
              }
            } else {
              checkPermissions();
              if (!fileExists) {
                startDownload();
              }
            }
          },
          icon: fileExists
              ? const Icon(
                  Icons.save,
                  color: Colors.green,
                )
              : dowloading
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        Text(
                          (progress * 100).toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : const Icon(Icons.download),
        ),
      ),
    );
  }
}
