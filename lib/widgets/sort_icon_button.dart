import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/helper.dart';
import '../providers/local_music_provider.dart';

class SortIconButton extends StatefulWidget {
  const SortIconButton({
    Key? key,
  }) : super(key: key);

  @override
  State<SortIconButton> createState() => _SortIconButtonState();
}

class _SortIconButtonState extends State<SortIconButton> {
  SortMethod selectedSortMethod = SortMethod.chronologicalDsc;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.sort),
      initialValue: selectedSortMethod,
      onSelected: (value) {
        setState(() {
          selectedSortMethod = value;
          Provider.of<LocalMusicProvider>(context, listen: false).sort(selectedSortMethod);
        });
      },
      itemBuilder: (context) {
        return <PopupMenuEntry<SortMethod>>[
          PopupMenuItem(
            enabled: false,
            child: Text(
              'Sort Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[300],
              ),
            ),
          ),
          PopupMenuItem(
            value: SortMethod.alphabeticalAsc,
            child: Text('A - Z'),
          ),
          PopupMenuItem(
            value: SortMethod.alphabeticalDsc,
            child: Text('Z - A'),
          ),
          PopupMenuItem(
            value: SortMethod.chronologicalDsc,
            child: Text('Newest'),
          ),
          PopupMenuItem(
            value: SortMethod.chronologicalAsc,
            child: Text('Oldest'),
          ),
          PopupMenuItem(
            value: SortMethod.random,
            child: Text('Random'),
          ),
        ];
      },
      onCanceled: () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}
