import 'package:audioplayer/audioplayer.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

AudioPlayer audioPlugin = new AudioPlayer();
String mp3UriFalse, mp3UriTrue;
List<String> mp3List = new List(9);
List<SoundProp> mp3Path = [
  SoundProp('assets/toy.mp3', '/toy.mp3'),
  SoundProp('assets/car.mp3', '/car.mp3'),
  SoundProp('assets/bell.mp3', '/bell.mp3'),
  SoundProp('assets/circle.mp3', '/cicle.mp3'),
  SoundProp('assets/correct.mp3', '/correct.mp3'),
  SoundProp('assets/ball.mp3', '/ball.mp3'),
];

Future<Null> load() async {
  for (int i = 0; i < 6; i++) {
    final ByteData data = await rootBundle.load(mp3Path[i].complatePath);
    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}${mp3Path[i].smallPath}');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
    mp3List[i] = tempFile.uri.toString();
    print('finished loading, uri=${mp3List[0]}');
  }
}

void playSound(int index) {
  if (mp3List[index] != null) {
    audioPlugin.play(mp3List[index], isLocal: true);
  }
}

class SoundProp {
  String complatePath, smallPath;
  SoundProp(this.complatePath, this.smallPath);
}
