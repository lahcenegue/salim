import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/constants.dart';

Widget shareButton({required String title, required String id}) {
  return IconButton(
    onPressed: () async {
      await Share.share('اسم المحاضرة: $title \n $kUrl/play/$id',
          subject: 'Look what I made!');
    },
    icon: const Icon(Icons.share_rounded),
  );
}
