import 'package:flutter/material.dart';
import 'package:masking/drawing.dart';
import 'package:flutter/services.dart';
import 'package:animated_background/animated_background.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(child: Animbackground()),
    );
  }
}

class Animbackground extends StatefulWidget {
  Animbackground({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AnimbackgroundState createState() => new _AnimbackgroundState();
}

class _AnimbackgroundState extends State<Animbackground>
    with TickerProviderStateMixin {
  ParticleOptions particleOptions = ParticleOptions(
    image: Image.asset('assets/autizem.png'),
    baseColor: Colors.blue,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.50,
    minOpacity: 0.1,
    maxOpacity: 0.5,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 20.0,
    particleCount: 100,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/BG-01.png'), fit: BoxFit.cover)),
            child: Drawing()));
  }
}
