import 'package:flutter/material.dart';
import 'package:tipot/pages/private/blank/blank.dart';
import 'package:tipot/pages/public/login_page/login.dart';
import 'package:tipot/pages/public/signup_page/signup.dart';

enum ActiveScreen { login, signup, blank }

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
  ActiveScreen activeScreen = ActiveScreen.login;

  Widget getActiveScreen(ActiveScreen screen) {
    switch (screen) {
      case ActiveScreen.login:
        return LoginPage(switchToSignUp,
            switchToBlank); // Replace with your login page widget
      case ActiveScreen.signup:
        return SignupPage(
            switchToLogin); // Replace with your signup page widget
      case ActiveScreen.blank:
        return const BlankPage();
      default:
        throw Exception('Invalid ActiveScreen value');
    }
  }


  @override
  void initState() {
    super.initState();
  }

  void switchToSignUp() {
    setState(() {
      activeScreen = ActiveScreen.signup;
    });
  }

  void switchToLogin() {
    setState(() {
      activeScreen = ActiveScreen.login;
    });
  }

  void switchToBlank() {
    setState(() {
      activeScreen = ActiveScreen.blank;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: getActiveScreen(activeScreen),
    );
  }
}
