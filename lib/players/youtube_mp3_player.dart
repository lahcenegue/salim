import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart' as bar;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/constants.dart';
import '../widgets/button_favorite.dart';
import '../widgets/download_item.dart';
import 'mp3_player_screen.dart';

class YoutubeMp3Player extends StatefulWidget {
  final String title;
  final String id;
  final List<String> videoUrls;

  const YoutubeMp3Player({
    super.key,
    required this.title,
    required this.id,
    required this.videoUrls,
  });

  @override
  State<YoutubeMp3Player> createState() => _YoutubeMp3PlayerState();
}

class _YoutubeMp3PlayerState extends State<YoutubeMp3Player> {
  //Audio part
  late AudioPlayer _audioPlayer;
  List<AudioSource> playListChildren = [];
  late String mp3Link;

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

  //Youtube Part
  late YoutubePlayerController _youtubePlayerController;
  late String youtubeLink;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.videoUrls.length; i++) {
      if (widget.videoUrls[i].contains('.mp3')) {
        mp3Link = widget.videoUrls[i];
      } else {
        youtubeLink = widget.videoUrls[i];
      }
    }
    _audioPlayer = AudioPlayer();
    _init();
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(youtubeLink)!,
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
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _youtubePlayerController.pause();
    super.deactivate();
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
            textAlign: TextAlign.center,
          ),
          actions: [
            ButtonFavorite(id: widget.id, title: widget.title),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //////////// youtube

            Expanded(
              child: Center(
                child: YoutubePlayerBuilder(
                  onExitFullScreen: () {
                    SystemChrome.setPreferredOrientations(
                        DeviceOrientation.values);
                  },
                  player: YoutubePlayer(
                    aspectRatio: 16 / 9,
                    controller: _youtubePlayerController,
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
            ),

            const Spacer(),
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
                      return bar.ProgressBar(
                        barHeight: widthScreen * 0.015,
                        baseBarColor: Colors.grey[600],
                        bufferedBarColor: Colors.grey,
                        progressBarColor: Colors.red,
                        thumbColor: Colors.red,
                        timeLabelTextStyle: TextStyle(
                          color: Colors.white,
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
                  const SizedBox(height: 8),
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
            DownloadItem(
              title: '1- ${widget.title}',
              url: mp3Link,
            ),
          ],
        ),
      ),
    );
  }
}
