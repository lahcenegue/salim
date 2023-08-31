import 'package:flutter/material.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/constants.dart';
import '../widgets/button_favorite.dart';
import '../widgets/download_item.dart';
import 'mp3_player_screen.dart';

class Mp3Mp4Player extends StatefulWidget {
  final String title;
  final String id;
  final List<String> videoUrls;

  const Mp3Mp4Player({
    super.key,
    required this.title,
    required this.id,
    required this.videoUrls,
  });

  @override
  State<Mp3Mp4Player> createState() => _Mp3Mp4PlayerState();
}

class _Mp3Mp4PlayerState extends State<Mp3Mp4Player> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  late AudioPlayer _audioPlayer;
  List<AudioSource> playListChildren = [];
  late String mp3Link;
  late Uri mp4Link;
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );
  Future<void> _init() async {
    final playList = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(
          Uri.parse(mp3Link),
          tag: MediaItem(
            id: widget.id,
            title: widget.title,
            artUri: Uri.parse(kSoundImage),
          ),
        ),
      ],
    );
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playList);
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.videoUrls.length; i++) {
      if (widget.videoUrls[i].contains('.mp3')) {
        mp3Link = widget.videoUrls[i];
      } else {
        mp4Link = Uri.parse(widget.videoUrls[i]);
      }
    }
    _audioPlayer = AudioPlayer();
    _init();
    videoPlayerController = VideoPlayerController.networkUrl(mp4Link)
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: widthScreen * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            ButtonFavorite(id: widget.id, title: widget.title),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController),
              ),
            ),
            const Divider(
              color: Colors.black,
              indent: 15,
              endIndent: 15,
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return ProgressBar(
                        barHeight: widthScreen * 0.015,
                        baseBarColor: Colors.grey[600],
                        bufferedBarColor: Colors.grey,
                        progressBarColor: Colors.red,
                        thumbColor: Colors.red,
                        timeLabelTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: widthScreen * 0.025,
                          fontWeight: FontWeight.w600,
                        ),
                        progress: positionData?.position ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: _audioPlayer.seek,
                      );
                    },
                  ),
                  Controls(
                    audioPlayer: _audioPlayer,
                    audioLength: playListChildren.length,
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
              indent: 15,
              endIndent: 15,
              height: 8,
            ),
            SizedBox(
              height: widthScreen * 0.22,
              child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.videoUrls.length,
                itemBuilder: (context, index) {
                  return DownloadItem(
                    title: '${index + 1}- ${widget.title}',
                    url: widget.videoUrls[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
