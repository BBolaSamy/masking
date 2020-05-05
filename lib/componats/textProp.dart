import 'package:flutter/material.dart';

class PrintText extends StatefulWidget {
  final String foo;

  const PrintText({Key key, this.foo}) : super(key: key);

  @override
  _MyStatefulState createState() => _MyStatefulState();
}

class _MyStatefulState extends State<PrintText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.foo,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}