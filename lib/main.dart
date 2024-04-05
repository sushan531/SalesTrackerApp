import 'package:flutter/material.dart';
import 'package:tipot/image_reader.dart';

void main() {
  runApp(const Tipot());
}

class Tipot extends StatefulWidget {
  const Tipot({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TipotState();
  }
}

class _TipotState extends State<Tipot> {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(),
      home: ImageReader(), // Your code here
    );
  }
}
