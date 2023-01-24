import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/models/music_player_arguments.dart';
import 'package:simple_music_player/providers/local_music_provider.dart';
import 'package:simple_music_player/screens/discover_tab.dart';
import 'package:simple_music_player/screens/extensive_music_player.dart';
import 'package:simple_music_player/screens/playlist_tab.dart';
import 'package:simple_music_player/screens/songs_tab.dart';
import 'package:simple_music_player/widgets/music_player.dart';
import 'package:simple_music_player/widgets/sort_icon_button.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocalMusicProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ExtensiveMusicPlayer.routeName:
              final value = settings.arguments as MusicPlayerArguments;
              return MaterialPageRoute(
                builder: (context) => ExtensiveMusicPlayer(
                  musicProvider: value.musicProvider,
                  audioPlayer: value.audioPlayer,
                  isPlaying: value.isPlaying,
                  isPaused: value.isPaused,
                  position: value.position,
                  duration: value.duration,
                  previousTrackId: value.previousTrackId,
                  songName: value.songName,
                  pauseOrResume: value.pauseOrResume,
                ),
              );
            default:
              return null;
          }
        },
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomSheet: MusicPlayer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Music Player'),
          actions: [
            IconButton(
              onPressed: () {
                // Provider.of<LocalMusicProvider>(context, listen: false).fetch();
                // _audioHandler.playMediaItem(MediaItem(id: id, title: title));
              },
              icon: Icon(Icons.refresh_rounded),
            ),
            SortIconButton(),
          ],
          bottom: TabBar(
            indicatorColor: Colors.blue[400],
            tabs: const [
              Tab(text: 'Songs'),
              Tab(text: 'Playlist'),
              Tab(text: 'Discover'),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: const [
            SongsTab(),
            PlaylistTab(),
            DiscoverTab(),
          ],
        ),
      ),
    );
  }
}
