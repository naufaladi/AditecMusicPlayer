import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/providers/local_music_provider.dart';

import 'custom_text_input.dart';

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final titleCtrl = TextEditingController();
  final artistCtrl = TextEditingController();

  @override
  void dispose() {
    titleCtrl.dispose();
    artistCtrl.dispose();
    super.dispose();
  }

  void onEditingComplete() {
    FocusManager.instance.primaryFocus?.unfocus();
    Provider.of<LocalMusicProvider>(context, listen: false).search(
      title: titleCtrl.text,
      artist: artistCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 60,
          child: CustomTextInput(
            controller: titleCtrl,
            hintText: "Title",
            onEditingComplete: onEditingComplete,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 15),
          child: Text(
            'by',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Expanded(
          flex: 50,
          child: CustomTextInput(
            controller: artistCtrl,
            hintText: "Artist",
            onEditingComplete: onEditingComplete,
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.search),
          splashRadius: 20,
          constraints: BoxConstraints(),
          padding: EdgeInsets.only(left: 5),
          onPressed: onEditingComplete,
        ),
      ],
    );
  }
}
