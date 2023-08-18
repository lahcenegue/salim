import 'package:flutter/material.dart';
import '../players/mp3_player_screen.dart';
import '../players/html_viewer_screen.dart';
import '../players/images_screen.dart';
import '../players/mp3_mp4_player.dart';
import '../players/mp4_player.dart';
import '../players/pdf_player_screen.dart';
import '../players/youtube_mp3_player.dart';
import '../players/youtube_player_screen.dart';
import '../view_model/content_view_model.dart';

Widget screenPiker(ContentViewModel contentViewModel) {
  List<String> type = [];

  if (contentViewModel.listLinks!.isEmpty) {
    return HtmlViwerScreen(
      id: contentViewModel.id,
      title: contentViewModel.name,
      text: contentViewModel.comment,
    );
  } else {
    for (int i = 0; i < contentViewModel.listLinks!.length; i++) {
      if (contentViewModel.listLinks![i].contains('mp3')) {
        type.add('Mp3');
      } else if (contentViewModel.listLinks![i].contains('mp4')) {
        type.add('Mp4');
      } else if (contentViewModel.listLinks![i].contains('youtube')) {
        type.add('Youtube');
      } else if (contentViewModel.listLinks![i].contains('pdf')) {
        type.add('PDF');
      } else {
        type.add('Image');
      }
    }

    if (type.contains('Mp3') && type.contains('Mp4')) {
      return Mp3Mp4Player(
        title: contentViewModel.name,
        id: contentViewModel.id,
        videoUrls: contentViewModel.listLinks!,
      );
    } else if (type.contains('Mp3') && type.contains('Youtube')) {
      return YoutubeMp3Player(
        title: contentViewModel.name,
        id: contentViewModel.id,
        videoUrls: contentViewModel.listLinks!,
      );
    } else if (type.contains('Mp3')) {
      return Mp3PlayerScreen(
        listLink: contentViewModel.listLinks!,
        id: contentViewModel.id,
        title: contentViewModel.name,
      );
    } else if (type.contains('Mp4')) {
      return Mp4PlayerScreen(
        videoUrl: contentViewModel.listLinks!.first,
        title: contentViewModel.name,
        id: contentViewModel.id,
      );
    } else if (type.contains('Youtube')) {
      return YoutubeVideoPlayerScreen(
        videoUrl: contentViewModel.listLinks!.first,
        title: contentViewModel.name,
        id: contentViewModel.id,
      );
    } else if (type.contains('PDF')) {
      return PdfPlayerScreen(
        link: contentViewModel.listLinks!.first,
        title: contentViewModel.name,
        id: contentViewModel.id,
      );
    } else if (type.contains('Image')) {
      return ImagesScreen(
        title: contentViewModel.name,
        imagesLinks: contentViewModel.listLinks!,
        id: contentViewModel.id,
      );
    }

    return const Scaffold(
      body: Center(
        child: Text('قريبا'),
      ),
    );
  }
}
