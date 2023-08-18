import 'package:dinetemp/widgets/button_favorite.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../constants/constants.dart';
import '../widgets/download_item.dart';

class Mp3PlayerScreen extends StatefulWidget {
  final List<String> listLink;
  final String id;
  final String title;
  const Mp3PlayerScreen({
    super.key,
    required this.listLink,
    required this.id,
    required this.title,
  });

  @override
  State<Mp3PlayerScreen> createState() => _Mp3PlayerScreenState();
}

class _Mp3PlayerScreenState extends State<Mp3PlayerScreen> {
  late AudioPlayer _audioPlayer;
  List<AudioSource> playListChildren = [];

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

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    String urlSound;
    for (int i = 0; i < widget.listLink.length; i++) {
      urlSound = widget.listLink[i];

      playListChildren.add(
        AudioSource.uri(
          Uri.parse(urlSound),
          tag: MediaItem(
            id: '${widget.id}$i',
            title: widget.title,
            artUri: Uri.parse(kSoundImage),
          ),
        ),
      );
    }

    final playList = ConcatenatingAudioSource(
      children: playListChildren,
    );
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playList);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            ButtonFavorite(id: widget.id, title: widget.title),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  kSoundImage,
                  height: heightScreen * 0.25,
                  width: widthScreen * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    barHeight: 8,
                    baseBarColor: Colors.grey[600],
                    bufferedBarColor: Colors.grey,
                    progressBarColor: Colors.red,
                    thumbColor: Colors.red,
                    timeLabelTextStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: _audioPlayer.seek,
                  );
                },
              ),
              Controls(
                audioPlayer: _audioPlayer,
                audioLength: playListChildren.length,
              ),
              const Spacer(),
              SizedBox(
                height: heightScreen * 0.22,
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playListChildren.length,
                  itemBuilder: (context, index) {
                    return DownloadItem(
                      title: '${index + 1}- ${widget.title}',
                      url: widget.listLink[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final int audioLength;
  const Controls({
    super.key,
    required this.audioPlayer,
    required this.audioLength,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: audioPlayer.seekToNext,
          iconSize: 60,
          color: audioLength <= 1 ? Colors.grey[700] : Colors.black,
          icon: const Icon(Icons.skip_next_rounded),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 80,
                color: Colors.black,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 80,
                color: Colors.black,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.black,
            );
          },
        ),
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          iconSize: 60,
          color: audioLength <= 1 ? Colors.grey[700] : Colors.black,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
      ],
    );
  }
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}
