import 'package:flutter/material.dart';

class PlaySpeed extends StatelessWidget {
  const PlaySpeed({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          child: Text('1x'),
        ),
      ),
    );
  }
}
