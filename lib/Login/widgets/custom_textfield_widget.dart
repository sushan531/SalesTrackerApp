import 'package:tipot/Login/index.dart';
import 'package:tipot/Login/utils/app_enum.dart';

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
}

class _CustomtextFieldState extends State<CustomtextField>
    with CustomTextFieldMixin {
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
