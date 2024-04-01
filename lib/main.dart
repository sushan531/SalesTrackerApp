import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final _storage = const FlutterSecureStorage();

  Widget getActiveScreen(ActiveScreen screen) {
    switch (screen) {
      case ActiveScreen.login:
        return LoginPage(switchToSignUp, switchToPrivate,
            _storage); // Replace with your login page widget
      case ActiveScreen.signup:
        return SignupPage(
            switchToLogin); // Replace with your signup page widget
      case ActiveScreen.blank:
        return BlankPage(_storage);
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

  void switchToPrivate() {
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
