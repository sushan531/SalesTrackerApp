import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tipot/Login/index.dart';



class SignUpPage extends StatefulWidget {
   const SignUpPage({super.key,

  });


  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              textfieldtype: TextFieldType.ispassword,
              icon: Icons.password_outlined,
            ),
            CustomtextField(
              textController: signupcontroller.organizationidcontroller,
              textfieldtype: TextFieldType.isorganizationid,
              icon: Icons.local_post_office_outlined,
            ),

            //

            const SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.only(top: 20),
              child: RichText(
                textAlign: TextAlign.center,
                  text: const TextSpan(
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
