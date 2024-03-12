import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tipot/Login/controllers/index.dart';
import 'package:tipot/Login/utils/app_enum.dart';
import 'package:tipot/Login/widgets/custom_textfield_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginpageState();
}

class _LoginpageState extends State<LoginPage> {
  LoginControllers logincontroller = Get.put(LoginControllers());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomtextField(
              textController: logincontroller.organizationidcontroller,
              textfieldtype: TextFieldType.isorganizationid,
            ),
            CustomtextField(
              textController: logincontroller.emailcontroller,
              textfieldtype: TextFieldType.isEmail,
            ),
            CustomtextField(
              textController: logincontroller.passwordcontroller,
              textfieldtype: TextFieldType.isnewpassword,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: 200,
              child: Center(
                child: InkWell(
                  onTap: () => logincontroller.loginwithEmail(),
                  child: Text(
                    "Login",
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
