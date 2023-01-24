import 'package:flutter/material.dart';

import '../widgets/search_bar.dart';
import '../widgets/song_list.dart';

class SongsTab extends StatefulWidget {
  const SongsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.grey.shade900,
          child: SearchBar(),
        ),
        Expanded(
          child: SongList(),
        ),
      ],
    );
  }
}
