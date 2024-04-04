import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tipot/screens/private/branches/branches.dart';
import 'package:tipot/screens/private/products/products.dart';
import 'package:tipot/screens/public/login_page/login.dart';
import 'package:tipot/screens/public/signup_page/signup.dart';

enum ActiveScreen { login, signup, product, branch }

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
        return LoginPage(switchToSignUp); // Replace with your login page widget
      case ActiveScreen.signup:
        return SignupPage(
            switchToLogin); // Replace with your signup page widget
      case ActiveScreen.product:
        return const ProductsScreen();
      case ActiveScreen.branch:
        return const BranchesScreen();

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
      activeScreen = ActiveScreen.product;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var accessToken = _storage.read(key: "access_token").toString();
    // TODO: verify expiry date
    // if (accessToken != "") {
    //   activeScreen = ActiveScreen.branch;
    // }
    return MaterialApp(
      theme: ThemeData(),
      home: getActiveScreen(activeScreen),
    );
  }
}
