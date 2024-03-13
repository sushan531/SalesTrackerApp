import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tipot/Login/index.dart';

import 'package:tipot/Login/widgets/custom_textfield_widget.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  SignupControllers signupcontroller = Get.put(SignupControllers());

  @override
  Widget build(BuildContext context) {
    return Container(
      // resizeToAvoidBottomInset: false,

      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            CustomtextField(
              textController: signupcontroller.emailcontroller,
              textfieldtype: TextFieldType.isEmail,
              icon: Icons.email_outlined,
            ),
            CustomtextField(
              textController: signupcontroller.passwordcontroller,
              textfieldtype: TextFieldType.isnewpassword,
              icon: Icons.password_outlined,
            ),
            CustomtextField(
              textController: signupcontroller.organizationidcontroller,
              textfieldtype: TextFieldType.isorganizationid,
              icon: Icons.local_post_office_outlined,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 20),
              child: RichText(
                textAlign: TextAlign.center,
                  text: TextSpan(
                text:"By pressing 'Submit' you agree to our",
                style: TextStyle(color: Color(0xFFc2dfda),
                fontSize: 12),
                children: [
                  TextSpan(
                    text: " term & conditions",
                    style: TextStyle(color: Colors.orange),
                  )
                ]

              )),
            )


          ],
        ),
      ),
    );
  }
}
