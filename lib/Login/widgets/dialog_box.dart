import 'package:flutter/material.dart';
import 'package:tipot/home/index.dart';
class MessageDialog extends StatelessWidget {
  const MessageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("SignUp Successful"),
      actions: [
        TextButton(onPressed:(){ Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));}, child: Text("Continue to Login >>"))
      ],

    );
  }
}
