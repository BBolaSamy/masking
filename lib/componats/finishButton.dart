import 'package:flutter/material.dart';
import 'package:masking/drawing.dart';
import 'package:masking/sound.dart';

class FinishButton extends StatelessWidget {
  final VoidCallback callback;
  final int soundNumber;
  final List<PathHistory> curruntColored;
  const FinishButton(
      {Key key, this.callback, this.curruntColored, this.soundNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playSound(soundNumber);
        callback();
        calPoint(curruntColored);
      },
      child: Container(
          child: Stack(
        children: <Widget>[
          Image.asset('assets/button-01-01.png'),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Press when Finish',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ))
        ],
      )),
    );
  }
}
