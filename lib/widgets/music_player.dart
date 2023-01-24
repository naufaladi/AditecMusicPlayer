import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/helpers/helper.dart';
import 'package:simple_music_player/models/music_player_arguments.dart';
import 'package:simple_music_player/providers/local_music_provider.dart';
import 'package:simple_music_player/screens/extensive_music_player.dart';

class MusicPlayer extends StatefulWidget {
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPaused = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  int previousTrackId = -1;

  List<int> savedTimestamps = [];

  final scrollCtrl = ScrollController();

  @override
  void initState() {
    print('initState called');
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      if (duration != newDuration) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (position.inSeconds != newPosition.inSeconds) {
        setState(() {
          position = newPosition;
        });
      }
    });

    audioPlayer.onPlayerComplete.listen((event) {
      position = Duration.zero;
      audioPlayer.pause();

      LocalMusicProvider musicProvider;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        musicProvider = Provider.of<LocalMusicProvider>(context, listen: false);
        musicProvider.goNextQueue();
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('music player didChangeDependencies called');
    final musicProvider = Provider.of<LocalMusicProvider>(context, listen: false);

    isPaused = false;
    savedTimestamps.clear();

    if (musicProvider.selectedTrack != null) {
      // this check is needed so the track doesnt restart when the provider fetch new item (and notifiesListener, thus calling didChangeDependency)
      if (musicProvider.selectedTrack!.id != previousTrackId) {
        playSelectedTrack();
      }
    }

    super.didChangeDependencies();
  }

  void playSelectedTrack() async {
    final musicProvider = Provider.of<LocalMusicProvider>(context, listen: false);

    position = Duration.zero;
    await audioPlayer.stop();
    await audioPlayer.setSourceUrl(musicProvider.selectedTrack!.filePath);
    await audioPlayer.resume();

    previousTrackId = musicProvider.selectedTrack!.id;
  }

  @override
  Widget build(BuildContext context) {
    var musicProvider = Provider.of<LocalMusicProvider>(context);
    var currentSong = musicProvider.selectedTrack;
    var songTitle = currentSong?.title;
    var songArtist = currentSong?.artist;

    // var customSlider = Row(
    //   children: [
    //     Text(formattedTimestamp(position.inSeconds)),
    //     Expanded(
    //       child: Slider(
    //         min: 0,
    //         max: duration.inSeconds.toDouble(),
    //         value: position.inSeconds.toDouble(),
    //         onChangeStart: (value) async {
    //           await audioPlayer.pause();
    //         },
    //         onChangeEnd: (value) async {
    //           await audioPlayer.seek(position);
    //           if (!isPaused) await audioPlayer.resume();
    //         },
    //         onChanged: (value) {
    //           setState(() {
    //             position = Duration(seconds: value.toInt());
    //           });
    //         },
    //       ),
    //     ),
    //     Text(formattedTimestamp(duration.inSeconds)),
    //   ],
    // );

    void pauseOrResume() async {
      if (isPlaying) {
        await audioPlayer.pause();
        isPaused = true;
      } else {
        isPaused = false;
        await audioPlayer.resume();
      }

      print(savedTimestamps.length);
    }

    return Container(
      color: Colors.grey.shade800,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 0, left: 15, right: 10),
            height: 84,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ExtensiveMusicPlayer.routeName,
                        arguments: MusicPlayerArguments(
                          musicProvider: musicProvider,
                          audioPlayer: audioPlayer,
                          isPlaying: isPlaying,
                          isPaused: isPaused,
                          position: position,
                          duration: duration,
                          previousTrackId: previousTrackId,
                          songName: songTitle,
                          pauseOrResume: pauseOrResume,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            songTitle ?? "No track selected",
                            style: songTitle == null
                                ? TextStyle(
                                    color: Colors.grey.shade500,
                                  )
                                : null,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.ltr,
                          ),
                          SizedBox(height: 4),
                          if (songArtist != null)
                            Text(
                              songArtist.isEmpty ? "Unknown Artist" : songArtist,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomButton(
                      icon: Icon(Icons.skip_previous),
                      onPressed: () async {
                        if (position < Duration(seconds: 5)) {
                          musicProvider.goPreviousQueue();
                        } else {
                          await audioPlayer.seek(Duration.zero);
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomButton(
                          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: songTitle == null ? null : pauseOrResume),
                    ),
                    CustomButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: () {
                        musicProvider.goNextQueue();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -24.1,
            left: 0,
            right: 0,
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
                activeTrackColor: Colors.blue,
                // inactiveTrackColor: Colors.white,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                rangeTrackShape: RectangularRangeSliderTrackShape(),
              ),
              child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChangeStart: (value) async {
                  await audioPlayer.pause();
                },
                onChangeEnd: (value) async {
                  await audioPlayer.seek(position);
                  if (!isPaused) await audioPlayer.resume();
                },
                onChanged: (value) {
                  setState(() {
                    position = Duration(seconds: value.toInt());
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect(
      {required RenderBox parentBox,
      Offset offset = Offset.zero,
      required SliderThemeData sliderTheme,
      bool isEnabled = false,
      bool isDiscrete = false}) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CustomButton extends StatelessWidget {
  final Icon icon;
  final void Function()? onPressed;
  const CustomButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: 28,
      splashRadius: 30,
      constraints: BoxConstraints(),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    );
  }
}
