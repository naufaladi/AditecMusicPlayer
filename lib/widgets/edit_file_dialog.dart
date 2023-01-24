import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:simple_music_player/providers/local_music_provider.dart';

import '../models/track.dart';

class EditFileDialog extends StatefulWidget {
  final LocalMusicProvider songProvider;
  final Track song;

  EditFileDialog({
    required this.songProvider,
    required this.song,
  });

  @override
  State<EditFileDialog> createState() => _EditFileDialogState();
}

class _EditFileDialogState extends State<EditFileDialog> {
  late final filePathCtrl = TextEditingController(
      text: widget.song.filePath.substring(0, widget.song.filePath.lastIndexOf("/") + 1));

  late final fileNameCtrl = TextEditingController(text: widget.song.fileName);
  late final newFileNameCtrl = TextEditingController(text: widget.song.fileName);
  late final titleCtrl = TextEditingController(text: widget.song.title);
  late final artistCtrl = TextEditingController(text: widget.song.artist);
  late final albumCtrl = TextEditingController(text: widget.song.album);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 25, left: 21, right: 21, bottom: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EDIT FILE DATA',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[300],
                  ),
                ),
                SizedBox(height: 17),
                TextFormField(
                  controller: artistCtrl,
                  decoration: InputDecoration(labelText: "Artist"),
                  onChanged: (newArtist) {
                    String newFileName = newFileNameCtrl.text;
                    int hyphenSeparatorIndex = newFileName.indexOf("-");
                    if (hyphenSeparatorIndex != -1) {
                      newFileName = newFileName.replaceRange(0, hyphenSeparatorIndex + 1, '');
                      newFileName = newFileName.trimLeft();
                    }
                    if (newArtist != '') newFileName = "$newArtist - $newFileName";

                    setState(() {
                      newFileNameCtrl.text = newFileName;
                    });
                  },
                ),
                TextFormField(
                  controller: titleCtrl,
                  decoration: InputDecoration(labelText: "Title"),
                  onChanged: (newTitle) {
                    String newFileName = newFileNameCtrl.text;
                    int hyphenSeparatorIndex = newFileName.indexOf("-");
                    int doubleSpaceSeparatorIndex = newFileName.lastIndexOf("  ");

                    String fileExtension = newFileName.substring(newFileName.lastIndexOf('.'));
                    newFileName = newFileName.substring(0, newFileName.lastIndexOf('.'));

                    if (hyphenSeparatorIndex != -1 && doubleSpaceSeparatorIndex != -1) {
                      newFileName = newFileName.replaceRange(
                          hyphenSeparatorIndex, doubleSpaceSeparatorIndex, "- $newTitle");
                    } else if (hyphenSeparatorIndex != -1) {
                      newFileName =
                          newFileName.replaceRange(hyphenSeparatorIndex, null, "- $newTitle");
                    } else if (doubleSpaceSeparatorIndex != -1) {
                      newFileName =
                          newFileName.replaceRange(0, doubleSpaceSeparatorIndex, newTitle);
                    } else {
                      newFileName = newFileName.replaceRange(0, null, newTitle);
                    }

                    newFileName += fileExtension;

                    setState(() {
                      newFileNameCtrl.text = newFileName;
                    });
                  },
                ),
                TextFormField(
                  controller: albumCtrl,
                  decoration: InputDecoration(labelText: "Album"),
                  onChanged: (newAlbum) {
                    String newFileName = newFileNameCtrl.text;
                    String fileExtension = newFileName.substring(newFileName.lastIndexOf('.'));
                    newFileName = newFileName.substring(0, newFileName.lastIndexOf('.')).trim();

                    int doubleSpaceSeparatorIndex = newFileName.lastIndexOf("  ");
                    if (doubleSpaceSeparatorIndex < newFileName.indexOf("-")) {
                      doubleSpaceSeparatorIndex = -1;
                    }

                    if (doubleSpaceSeparatorIndex != -1) {
                      newFileName = newFileName.replaceRange(doubleSpaceSeparatorIndex, null, '');
                    }

                    if (newAlbum != '') {
                      newFileName = "$newFileName  $newAlbum";
                    }

                    newFileName = newFileName + fileExtension;
                    setState(() {
                      newFileNameCtrl.text = newFileName;
                    });
                  },
                ),
                SizedBox(height: 25),
                CustomOutlinedTextInput(
                  filePathCtrl: newFileNameCtrl,
                  labelText:
                      fileNameCtrl.text != newFileNameCtrl.text ? "New File Name" : "File Name",
                  isImportant: fileNameCtrl.text != newFileNameCtrl.text,
                ),
                SizedBox(height: 17),
                CustomOutlinedTextInput(
                  filePathCtrl: filePathCtrl,
                  labelText: "File Path",
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.grey[350]),
                      child: Text("CANCEL"),
                    ),
                    TextButton(
                      onPressed: () async {
                        Provider.of<LocalMusicProvider>(context, listen: false).renameFile(
                          filePath: widget.song.filePath,
                          newFileName: newFileNameCtrl.text,
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.blue[300]),
                      child: Text("APPLY"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOutlinedTextInput extends StatelessWidget {
  const CustomOutlinedTextInput({
    Key? key,
    required this.filePathCtrl,
    required this.labelText,
    this.isImportant = false,
  }) : super(key: key);

  final TextEditingController filePathCtrl;
  final String labelText;
  final bool isImportant;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: TextFormField(
        controller: filePathCtrl,
        style: TextStyle(),
        enabled: false,
        expands: true,
        maxLines: null,
        minLines: null,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: isImportant
              ? TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                )
              : null,
          isDense: true,
          border: OutlineInputBorder(),
          disabledBorder: isImportant
              ? OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightGreen,
                    width: 2,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
