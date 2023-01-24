import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:simple_music_player/providers/local_music_provider.dart';
import 'package:simple_music_player/widgets/music_player.dart';

class ExtensiveMusicPlayer extends StatefulWidget {
  static const String routeName = 'extensive-music-player';

  ExtensiveMusicPlayer({
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

  @override
  State<ExtensiveMusicPlayer> createState() => _ExtensiveMusicPlayerState();
}

class _ExtensiveMusicPlayerState extends State<ExtensiveMusicPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              color: Colors.white,
            ),
            SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
                activeTrackColor: Colors.blue,
                // inactiveTrackColor: Colors.white,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                rangeTrackShape: RectangularRangeSliderTrackShape(),
              ),
              child: Slider(
                min: 0,
                max: widget.duration.inSeconds.toDouble(),
                value: widget.position.inSeconds.toDouble(),
                onChangeStart: (value) async {
                  await widget.audioPlayer.pause();
                },
                onChangeEnd: (value) async {
                  await widget.audioPlayer.seek(widget.position);
                  if (!widget.isPaused) await widget.audioPlayer.resume();
                },
                onChanged: (value) {
                  setState(() {
                    widget.position = Duration(seconds: value.toInt());
                  });
                },
              ),
            ),
            Row(
              children: [
                CustomButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () async {
                    if (widget.position < Duration(seconds: 5)) {
                      widget.musicProvider.goPreviousQueue();
                    } else {
                      await widget.audioPlayer.seek(Duration.zero);
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: CustomButton(
                    icon: Icon(widget.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: widget.songName == null ? null : widget.pauseOrResume,
                  ),
                ),
                CustomButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () {
                    widget.musicProvider.goNextQueue();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
