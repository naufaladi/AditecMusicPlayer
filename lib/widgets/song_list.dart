import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/providers/local_music_provider.dart';
import 'package:simple_music_player/widgets/edit_file_dialog.dart';

import '../helpers/helper.dart';
import '../models/track.dart';
import '../providers/asset_music_provider.dart';

enum SongListMode {
  favorites,
  lastPlayed,
  all,
}

class SongList extends StatefulWidget {
  SongListMode songListMode;
  SongList({
    this.songListMode = SongListMode.all,
  });

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  List<Track> songs = [];
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      print('isloading is true!');
      isLoading = true;
    });
    Provider.of<LocalMusicProvider>(context, listen: false).fetch().then((_) {
      setState(() {
        print('isLoading is false');
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<LocalMusicProvider>(context);

    if (widget.songListMode == SongListMode.all) {
      songs = songProvider.displayedItems;
    }

    return isLoading
        ? Container(
            alignment: Alignment.center,
            child: Text(
              'Fetching music from Internal_storage/Music/...',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
              ),
            ),
          )
        : ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return StatefulBuilder(
                builder: (context, setStateChild) {
                  bool isSelected = song.id == songProvider.selectedTrack?.id;

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    color: isSelected ? Colors.blue[700] : Colors.grey.shade900,
                    child: ListTile(
                      horizontalTitleGap: 0,
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(),
                        ),
                      ),
                      subtitle: Text(song.artist.isEmpty ? "Unknown Artist" : song.artist),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return TrackMenuDialog(
                                songProvider: songProvider,
                                song: song,
                              );
                            },
                          );
                        },
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.only(left: 20),
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey[500],
                          size: 22,
                        ),
                      ),
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Provider.of<LocalMusicProvider>(context, listen: false)
                            .setPlayingQueue(songs[index].id);
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}

class TrackMenuDialog extends StatelessWidget {
  const TrackMenuDialog({
    Key? key,
    required this.songProvider,
    required this.song,
  }) : super(key: key);

  final LocalMusicProvider songProvider;
  final Track song;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Colors.grey.shade800,
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditFileDialog(
                        songProvider: songProvider,
                        song: song,
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    'Edit',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await songProvider.deleteFile(song.filePath).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    'Delete',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
