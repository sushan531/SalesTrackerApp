import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:tipot/Login/screens/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool Taplogin = false;
  bool TapSignup = false;
  Widget topWidget(double screenWidth) {
    return Container(
      width: 0.95 * screenWidth,
      height: 1.35 * screenWidth,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 2),
            // Offset of the shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(10)),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Taplogin = true;
                    });
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF173e38),
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 30,
                  thickness: 1,
                  color: Colors.black, // Thickness of the vertical line
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      TapSignup = true;
                    });
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          if (Taplogin == false) LoginPage(),
          if (Taplogin == true) LoginPage(),
          if (TapSignup == true) SignUpPage(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF338B7E),
      body: Stack(children: [
        Positioned(
          left: 30, // Adjust the left position as needed
          top: 180, // Adjust the top position as needed
          child: Text(
            "TIPOT",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 220,
          child: topWidget(screenSize.width),
        )
      ]),
    );

    // return Scaffold(
    //   backgroundColor: Colors.amber,
    //   body: Center(
    //     child: Column(children: [
    //       SizedBox(
    //         height: 270,
    //       ),
    //       Container(
    //         height: 50,
    //         width: 200,
    //         child: Center(
    //           child: InkWell(
    //             onTap: () => Navigator.of(context).push(
    //                 MaterialPageRoute(builder: (context) => SignUpPage())),
    //             child: Text(
    //               "Sign Up",
    //               style: TextStyle(color: Colors.black),
    //             ),
    //           ),
    //         ),
    //         decoration: BoxDecoration(
    //             color: Color.fromARGB(255, 232, 219, 182),
    //             borderRadius: BorderRadius.circular(20)),
    //       ),
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Container(
    //         height: 50,
    //         width: 200,
    //         child: Center(
    //           child: InkWell(
    //             onTap: () => Navigator.of(context)
    //                 .push(MaterialPageRoute(builder: (context) => LoginPage())),
    //             child: Text(
    //               "Login",
    //               style: TextStyle(color: Colors.black),
    //             ),
    //           ),
    //         ),
    //         decoration: BoxDecoration(
    //             color: Color.fromARGB(255, 232, 219, 182),
    //             borderRadius: BorderRadius.circular(20)),
    //       ),
    //     ]),
    //   ),
    // );
  }
}
