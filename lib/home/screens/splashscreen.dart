import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tipot/home/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF25665C),
      body: Center(
          child: Stack(children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Text(
            "TIPOT",
            style: TextStyle(
              fontSize: 50,
              color: Color(0xFF276D62),
              fontWeight: FontWeight.bold,
              // foreground: Paint()
              //   ..style = PaintingStyle.stroke
              //   ..strokeWidth = 4.0 // Width of the stroke
              //   ..color = Color(0xFF18555A),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Text(
              'TIPOT',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Color(0x44BCA9),
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
