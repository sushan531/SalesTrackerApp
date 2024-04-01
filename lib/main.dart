import 'package:flutter/material.dart';
import 'package:tipot/pages/login_page/login.dart';
import 'package:tipot/pages/signup_page/signup.dart';

enum ActiveScreen { login, signup }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(),
        home: activeScreen == ActiveScreen.login
            ? LoginPage(switchToSignUp)
            : SignupPage(switchToLogin));
  }
}
