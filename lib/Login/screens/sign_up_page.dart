import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tipot/Login/index.dart';

import 'package:tipot/Login/widgets/custom_textfield_widget.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  SignupControllers signupcontroller = Get.put(SignupControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 232, 219, 182),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Register Here",
          style:
              TextStyle(fontSize: 30, color: Color.fromARGB(255, 65, 64, 60)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomtextField(
              textController: signupcontroller.emailcontroller,
              textfieldtype: TextFieldType.isEmail,
            ),
            CustomtextField(
              textController: signupcontroller.passwordcontroller,
              textfieldtype: TextFieldType.isnewpassword,
            ),
            CustomtextField(
              textController: signupcontroller.organizationidcontroller,
              textfieldtype: TextFieldType.isorganizationid,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 200,
              child: Center(
                child: InkWell(
                  onTap: () =>
                      Get.find<SignupControllers>().registerwithEmail(),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    );
  }
}
