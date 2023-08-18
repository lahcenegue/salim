import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constants/constants.dart';
import '../widgets/button_favorite.dart';

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String id;
  const YoutubeVideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.id,
  });

  @override
  State<YoutubeVideoPlayerScreen> createState() =>
      _YoutubeVideoPlayerScreenState();
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            ButtonFavorite(id: widget.id, title: widget.title),
          ],
        ),
        body: YoutubePlayerBuilder(
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: kMainColor,
            bottomActions: [
              CurrentPosition(),
              ProgressBar(
                isExpanded: true,
                colors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.red,
                  backgroundColor: Colors.grey,
                  bufferedColor: Colors.white,
                ),
              ),
              RemainingDuration(),
              FullScreenButton(),
            ],
          ),
          builder: (context, player) {
            return player;
          },
        ),
      ),
    );
  }
}
