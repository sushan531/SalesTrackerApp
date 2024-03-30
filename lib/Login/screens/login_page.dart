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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [

          CustomtextField(
            textController: logincontroller.organizationidcontroller,
            textfieldtype: TextFieldType.isorganizationid,
            icon: Icons.local_post_office_outlined,
          ),
          CustomtextField(
            textController: logincontroller.emailcontroller,
            textfieldtype: TextFieldType.isEmail,
            icon: Icons.email_outlined,
          ),
          CustomtextField(
            textController: logincontroller.passwordcontroller,
            textfieldtype: TextFieldType.ispassword,
            icon: Icons.password_outlined,
          ),
          SizedBox(
            height: 20,
          ),

        ],
      ),
    );
  }
}
