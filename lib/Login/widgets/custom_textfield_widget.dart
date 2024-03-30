import 'package:tipot/Login/index.dart';
import 'package:tipot/Login/utils/app_enum.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

class CustomtextField extends StatefulWidget {
  CustomtextField({
    Key? key,
    required this.textController,
    required this.textfieldtype,
    required this.icon,
  });

  TextEditingController textController = TextEditingController();
  TextFieldType textfieldtype;
  IconData icon;

  @override
  State<CustomtextField> createState() => _CustomtextFieldState();
  void Validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    print(isvalid);
  }
}

class _CustomtextFieldState extends State<CustomtextField>
    with CustomTextFieldMixin {
  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }
  String? validatorfunction({required String? value}) {
    if (isValid(
          widget.textfieldtype,
          value,
        ) ==
        "") {
      return null;
    } else {
      return isValid(widget.textfieldtype, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),

        TextFormField(
          controller: widget.textController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon, color: Color(0xFFc2dfda), size: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Color(0xFFc2dfda)),
              borderRadius:
              BorderRadius.all(Radius.circular(35.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Color(0xFFc2dfda)),
              borderRadius:
              BorderRadius.all(Radius.circular(35.0)),
            ),


            hintText: getHintText(widget.textfieldtype),
            hintStyle: TextStyle(fontSize: 14, color: Color(0xFFc2dfda)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
          ),
          validator: ((value) => validatorfunction(value: value)),

          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
