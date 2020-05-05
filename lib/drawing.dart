import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:masking/timer.dart';
import 'componats/textProp.dart';
import 'componats/finishButton.dart';
import 'dependenuces.dart';
import 'sound.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:koukicons/download.dart';
import 'package:koukicons/camera.dart';
import 'package:koukicons/speaker.dart';

class Drawing extends StatefulWidget {
  @override
  _DrawingState createState() => new _DrawingState();
}

String presetange = '';

String calPoint(List<PathHistory> colored) {
  List<Offset> allPoints = [];
  List<Offset> allColored = [];
  for (int i = 0; i < colored.length; i += 5) {
    if (colored[i].points != null && colored[i + 1].points != null) {
      allColored.add(Offset(colored[i].points.dx.round().toDouble(),
          colored[i].points.dy.round().toDouble()));
    }
  }
  // print('before ${allColored.length}');
  allColored = allColored.toSet().toList();
  // print('After ${allColored.length} ${allColored} ');

  for (double x = 0; x < 250; x += 5) {
    for (double y = 0; y < 250; y++) {
      allPoints.add(Offset(x, y));
    }
  }
  int count = 0;
  for (int i = 0; i < allColored.length; i++) {
    if (allPoints.contains(allColored[i])) {
      count++;
      allPoints.remove(allColored[i]);
    }
  }
  // print(count);
  // print(allPoints.length);
  var result = ((count / 8) * 100).round();
  var score;
  if (result >= 100) {
    score = 'excellent';
  } else if (result >= 80) {
    score = 'good';
  } else if (result >= 50) {
    score = 'okay';
  } else {
    score = 'bad';
  }
  // print('result is $result%');

  presetange = score;
  return score;
}

enum PaintChoice { Paint, Eraser, Masking }

class _DrawingState extends State<Drawing> {
  void stopWatch() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  int currentQuestion = 0;
  PaintController _paintController = new PaintController();
  PaintChoice choice = PaintChoice.Masking;
  final Dependencies dependencies = new Dependencies();

  List<ImagePaths> allImagesPaths = [
    //1
    ImagePaths(
        'Circle', 'assets/coloredCircle.png', 'assets/unColoredCircle.png', 3),
    //2
    ImagePaths(
        'Square', 'assets/coloredSquare.png', 'assets/unColoredsquare.png', 3),
    //3
    ImagePaths('Traingle', 'assets/coloredtTaingle.png',
        'assets/unColoredTraingle.png', 3),
    //4
    ImagePaths('Star', 'assets/coloredStar.png', 'assets/unColoredStar.png', 3),
    //5
    ImagePaths('Cube', 'assets/coloredCube.png', 'assets/unColoredCube.png', 3),
    //6
    ImagePaths(
        'Ball', 'assets/coloredBall2.png', 'assets/unColoredBall2.png', 5),
    //7
    ImagePaths(
        'Bell', 'assets/coloredBell3.png', 'assets/unColoredBell2.png', 2),
    //8
    ImagePaths('Toy', 'assets/coloredToy2.png', 'assets/unColoredToy.png', 0),
    //9
    ImagePaths('Car', 'assets/coloredCar2.png', 'assets/unColoredCar2.png', 1),
  ];
  Color currentColor = Colors.red;
  double _value = 50;
  ui.Image image;
  @override
  void initState() {
    super.initState();
    load();
    dependencies.stopwatch.start();
    cacheImage(allImagesPaths[currentQuestion].coloredPath);
  }

  Future<void> cacheImage(String asset) async {
    try {
      ByteData data = await rootBundle.load(asset);
      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      image = fi.image;
      print(image);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 5, left: 5),
      child: Column(
        children: <Widget>[
          Container(
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TimerPage(
                  dependencies: dependencies,
                ),
                CircularGradientButton(
                  child: Icon(Icons.arrow_back),
                  callback: () {
                    setState(() {
                      if (currentQuestion == 0) {
                      } else {
                        currentQuestion--;
                      }
                      cacheImage(allImagesPaths[currentQuestion].coloredPath);
                      _paintController.clear();
                    });
                  },
                  gradient: Gradients.buildGradient(
                    Alignment.topCenter,
                    Alignment.bottomCenter,
                    [Colors.blue, Colors.blue[900]],
                  ),
                  shadowColor:
                      Gradients.rainbowBlue.colors.last.withOpacity(0.5),
                ),
                CircularGradientButton(
                  child: Icon(Icons.arrow_forward),
                  callback: () {
                    setState(() {
                      if (currentQuestion == 8) {
                        currentQuestion = 0;
                      } else {
                        currentQuestion++;
                      }
                      cacheImage(allImagesPaths[currentQuestion].coloredPath);
                      _paintController.clear();
                    });
                  },
                  gradient: Gradients.buildGradient(
                    Alignment.topCenter,
                    Alignment.bottomCenter,
                    [Colors.blue, Colors.blue[900]],
                  ),
                  shadowColor:
                      Gradients.rainbowBlue.colors.last.withOpacity(0.5),
                ),
                PrintText(foo: 'sketch number: ${currentQuestion + 1}'),
                FinishButton(
                  curruntColored: _paintController.pathHistory,
                  callback: stopWatch,
                  soundNumber: allImagesPaths[currentQuestion].soundNumber,
                ),
                CircularGradientButton(
                  child: Icon(Icons.clear),
                  callback: () {
                    choice = PaintChoice.Masking;
                    _paintController.clear();
                    setState(() {});
                  },
                  gradient: Gradients.buildGradient(
                    Alignment.topCenter,
                    Alignment.bottomCenter,
                    [Colors.red, Colors.red[900]],
                  ),
                  shadowColor:
                      Gradients.rainbowBlue.colors.last.withOpacity(0.5),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xff35D461),
                        child: IconButton(
                          iconSize: 60,
                          onPressed: () {},
                          icon: KoukiconsDownload(
                            color: Color(0xffF882FF6),
                            width: 100,
                            height: 100,
                          ),
                        )

                        // CircularGradientButton(
                        //   child: KoukiconsDownload(
                        //     color: Colors.white,
                        //   ),
                        //   //  Icon(
                        //   //   Icons.file_download,
                        //   //   size: 55,
                        //   // ),
                        //   callback: () {},
                        //   gradient: Gradients.buildGradient(
                        //     Alignment.topCenter,
                        //     Alignment.bottomCenter,
                        //     [Colors.blue, Colors.blue[900]],
                        //   ),
                        //   shadowColor:
                        //       Gradients.rainbowBlue.colors.last.withOpacity(0.5),
                        // ),
                        //     GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     child: Image.asset('assets/save button-01-01.png'),
                        //   ),
                        // ),
                        ),
                    Container(
                      height: 10,
                    ),
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xff35D461),
                        child: IconButton(
                          iconSize: 60,
                          onPressed: () {},
                          icon: KoukiconsCamera(
                            // color: Color(0xffF882FF6),
                            width: 100,
                            height: 100,
                          ),
                        )
                        // CircularGradientButton(
                        //   child: Icon(
                        //     Icons.photo_camera,
                        //     size: 50,
                        //   ),
                        //   callback: () {},
                        //   gradient: Gradients.buildGradient(
                        //     Alignment.topCenter,
                        //     Alignment.bottomCenter,
                        //     [Colors.blue, Colors.blue[900]],
                        //   ),
                        //   shadowColor:
                        //       Gradients.rainbowBlue.colors.last.withOpacity(0.5),
                        // ),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     child: Image.asset(
                        //         'assets/camera button-01-01-01-01.png'),
                        //   ),
                        // ),
                        ),
                    Container(
                      height: 10,
                    ),
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xff35D461),
                        child: IconButton(
                          iconSize: 60,
                          onPressed: () {},
                          icon: KoukiconsSpeaker(
                            color: Color(0xffF882FF6),
                            width: 100,
                            height: 100,
                          ),
                        )
                        // CircularGradientButton(
                        //   child: Icon(
                        //     Icons.speaker,
                        //     size: 55,
                        //     color: Colors.white,
                        //   ),
                        //   callback: () {},
                        //   gradient: Gradients.buildGradient(
                        //     Alignment.topCenter,
                        //     Alignment.bottomCenter,
                        //     [Colors.blue, Colors.blue[900]],
                        //   ),
                        //   shadowColor:
                        //       Gradients.rainbowBlue.colors.last.withOpacity(0.5),
                        // ),
                        //  GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     child: Image.asset('assets/sound button-01-01.png'),
                        //   ),
                        // ),
                        ),
                  ],
                ),
              ),
              Container(
                width: 100,
              ),
              Container(
                height: 285,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/sketch2.png',
                      ),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    right: 20.0,
                    left: 20,
                    bottom: 2.0,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 2, color: Colors.transparent),
                        ),
                        child: prefix0.Image.asset(
                          allImagesPaths[currentQuestion].unColoredPath,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.black),
                        ),
                        width: 262,
                        height: 246,
                        child: CustomPaint(
                          child: RepaintBoundary(
                            child: GestureDetector(
                              onPanUpdate: (s) {
                                Offset pos =
                                    (context.findRenderObject() as RenderBox)
                                        .globalToLocal(s.globalPosition);
                                pos = pos.translate(-250, -70);
                                _paintController.addPoint(
                                    offset: pos,
                                    choice: choice,
                                    image: image,
                                    strokeWidth: _value);
                              },
                              onPanEnd: (e) {
                                _paintController.addPoint(
                                    offset: null,
                                    choice: choice,
                                    image: image,
                                    strokeWidth: _value);
                              },
                            ),
                          ),
                          painter: _Paint(
                              controller: _paintController,
                              repaint: _paintController),
                        ),
                      ),
                      //   Image.asset(
                      //     'assets/sketch-01.png',
                      //     width: 300,
                      //     height: 300,
                      //     fit: BoxFit.cover,
                      //     // width: 300,
                      //     // height: 400,
                      //   ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'your grade is:\n $presetange',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Paint extends CustomPainter {
  _Paint({this.controller, Listenable repaint}) : super(repaint: repaint);
  PaintController controller;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (int i = 0; i < controller.pathHistory.length - 1; i++) {
      // print(controller.pathHistory[i].points);
      if (controller.pathHistory[i].points != null &&
          controller.pathHistory[i + 1].points != null) {
        canvas.drawLine(
            controller.pathHistory[i].points,
            controller.pathHistory[i + 1].points,
            controller.pathHistory[i].paint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_Paint oldDelegate) =>
      oldDelegate.controller.pathHistory != controller.pathHistory;
}

class PathHistory {
  Offset points;
  Paint paint;
  PaintChoice paintChoice;
  ui.Image image;
  final double devicePixelRatio = ui.window.devicePixelRatio;
  PathHistory(
      {Offset offset,
      ui.Image image,
      PaintChoice paintChoice,
      double strokeWidth}) {
    this.paintChoice = paintChoice;
    points = offset;
    final Float64List deviceTransform = new Float64List(16)
      ..[0] = 10
      ..[5] = 10
      ..[10] = 10
      ..[15] = 10;
    paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;
    switch (paintChoice) {
      case PaintChoice.Paint:
        break;
      case PaintChoice.Masking:
        paint.shader = ImageShader(
            image, TileMode.repeated, TileMode.repeated, deviceTransform);
        break;
      case PaintChoice.Eraser:
        paint.blendMode = BlendMode.clear;
    }
  }
}

class PaintController extends ChangeNotifier {
  List<PathHistory> pathHistory = [];
  void addPoint(
      {Offset offset,
      PaintChoice choice,
      ui.Image image,
      double strokeWidth = 10}) {
    pathHistory.add(PathHistory(
        offset: offset,
        paintChoice: choice,
        image: image,
        strokeWidth: strokeWidth));
    notifyListeners();
  }

  void clear() {
    pathHistory.clear();
    notifyListeners();
  }
}

class ImagePaths {
  String coloredPath, unColoredPath, imageName;
  int soundNumber;
  ImagePaths(
      this.imageName, this.coloredPath, this.unColoredPath, this.soundNumber);
}
