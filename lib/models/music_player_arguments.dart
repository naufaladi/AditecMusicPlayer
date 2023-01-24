import 'package:audioplayers/audioplayers.dart';
import 'package:simple_music_player/providers/local_music_provider.dart';

class MusicPlayerArguments {
  MusicPlayerArguments({
    required this.musicProvider,
    required this.audioPlayer,
    required this.isPlaying,
    required this.isPaused,
    required this.position,
    required this.duration,
    required this.previousTrackId,
    required this.songName,
    required this.pauseOrResume,
  });

  final AudioPlayer audioPlayer;
  final LocalMusicProvider musicProvider;
  bool isPlaying;
  bool isPaused;
  Duration position;
  Duration duration;

  void Function() pauseOrResume;

  int previousTrackId;
  String? songName;
}
