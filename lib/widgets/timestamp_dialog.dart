import 'package:flutter/material.dart';
import 'package:simple_music_player/widgets/music_player.dart';

import '../helpers/helper.dart';

class TimestampDialog extends StatefulWidget {
  final int timestamp;
  final void Function() onDelete;
  final void Function(int) onApply;

  const TimestampDialog({
    required this.timestamp,
    required this.onDelete,
    required this.onApply,
  });

  @override
  State<TimestampDialog> createState() => _TimestampDialogState();
}

class _TimestampDialogState extends State<TimestampDialog> {
  int tempTimestamp = 0;

  @override
  void initState() {
    tempTimestamp = widget.timestamp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 290,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Adjust Timestamp'),
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            tempTimestamp--;
                          });
                        },
                        padding: EdgeInsets.only(),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.remove_circle_outline),
                      ),
                      SizedBox(width: 15),
                      Text(formattedTimestamp(tempTimestamp)),
                      SizedBox(width: 15),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            tempTimestamp++;
                          });
                        },
                        padding: EdgeInsets.only(),
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.add_circle_outline_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: widget.onDelete,
                  child: Text('Delete'),
                ),
                ElevatedButton(
                  child: Text('Apply'),
                  onPressed: () => widget.onApply(tempTimestamp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
