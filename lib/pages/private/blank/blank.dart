import 'package:flutter/cupertino.dart';

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(40),
      child: Text("You have been logged in"),
    );
  }
}
