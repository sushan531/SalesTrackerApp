import 'package:flutter/material.dart';

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
    // var accessToken = _storage.read(key: "access_token").toString();
    // TODO: verify expiry date
    // if (accessToken != "") {
    //   activeScreen = ActiveScreen.branch;
    // }
    return MaterialApp(
      theme: ThemeData(),
      home: Container(), // Your code here
    );
  }
}
