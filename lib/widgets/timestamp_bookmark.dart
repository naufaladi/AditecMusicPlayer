import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:simple_music_player/widgets/music_player.dart';
import 'package:simple_music_player/widgets/timestamp_dialog.dart';

import '../helpers/helper.dart';

class TimestampBookmark extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final Function seekTimestamp;
  final List savedTimestamps;

  const TimestampBookmark({
    super.key,
    required this.audioPlayer,
    required this.seekTimestamp,
    required this.savedTimestamps,
  });

  @override
  State<TimestampBookmark> createState() => _TimestampBookmarkState();
}

class _TimestampBookmarkState extends State<TimestampBookmark> {
  late double timestampNavigatorWidth;
  late double timestampContainerWidth;
  double timestampContainerMargin = 10;
  double addTimestampContainerWidth = 30;

  final scrollCtrl = ScrollController();

  double get selectedTimestamp =>
      ((scrollCtrl.offset + timestampContainerWidth + timestampContainerMargin) /
          (timestampContainerWidth + timestampContainerMargin));

  void scrollPagination({required bool goPrevious}) async {
    double timestampWidth = timestampContainerWidth + timestampContainerMargin;
    await scrollCtrl.animateTo(
      goPrevious
          ? timestampWidth * (selectedTimestamp - 2).round()
          : timestampWidth * (selectedTimestamp).floor(),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void addTimestamp() async {
    Duration? trackDuration = await widget.audioPlayer.getDuration();

    if (trackDuration != null) {
      Duration? currentPosition = await widget.audioPlayer.getCurrentPosition();

      setState(() {
        widget.savedTimestamps.add(currentPosition!.inSeconds);
        widget.savedTimestamps.sort();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          height: 32,
          alignment: Alignment.center,
          child: Text('Select a song first'),
        ),
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.zero,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    timestampNavigatorWidth = (MediaQuery.of(context).size.width - 20) * 0.75;
    timestampContainerWidth =
        timestampNavigatorWidth - addTimestampContainerWidth * 3 - timestampContainerMargin * 3;

    return Container(
      height: 40,
      width: timestampNavigatorWidth,
      margin: EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      // decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            child: InkWell(
              borderRadius: BorderRadius.circular(3),
              onTap: () => scrollPagination(goPrevious: true),
              child: Container(
                width: addTimestampContainerWidth,
                padding: EdgeInsets.only(right: 1.5),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.blue,
                  size: 15,
                ),
              ),
            ),
          ),
          Container(
            width: (timestampContainerWidth + timestampContainerMargin * 2) +
                (addTimestampContainerWidth + timestampContainerMargin),
            child: SingleChildScrollView(
              controller: scrollCtrl,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: () {
                  List<Widget> widgets = [];
                  for (int index = 0; index < widget.savedTimestamps.length; index++) {
                    widgets.add(
                      Container(
                        key: Key(index.toString()),
                        margin: EdgeInsets.only(left: timestampContainerMargin),
                        child: Material(
                          borderRadius: BorderRadius.circular(7),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(7),
                            onTap: () => widget.seekTimestamp(widget.savedTimestamps[index]),
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (context) {
                                return TimestampDialog(
                                  timestamp: widget.savedTimestamps[index],
                                  onDelete: () {
                                    setState(() {
                                      widget.savedTimestamps.removeAt(index);
                                      print(widget.savedTimestamps.length);
                                      Navigator.pop(context);
                                    });
                                  },
                                  onApply: (newTimestamp) {
                                    setState(() {
                                      widget.savedTimestamps[index] = newTimestamp;
                                      Navigator.pop(context);
                                      // label = labelCtrl.text;
                                    });
                                  },
                                );
                              },
                            ),
                            child: Container(
                              width: timestampContainerWidth,
                              alignment: Alignment.center,
                              child: Text(formattedTimestamp(widget.savedTimestamps[index])),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  widgets.add(
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: timestampContainerMargin,
                        vertical: 1,
                      ),
                      child: Material(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(7),
                          onTap: addTimestamp,
                          child: Container(
                            width: addTimestampContainerWidth,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  return widgets;
                }(),
              ),
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            child: InkWell(
              borderRadius: BorderRadius.circular(3),
              onTap: () => scrollPagination(goPrevious: false),
              child: Container(
                width: addTimestampContainerWidth,
                padding: EdgeInsets.only(left: 1.5),
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
