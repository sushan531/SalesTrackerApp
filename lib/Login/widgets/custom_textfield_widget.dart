import 'package:tipot/Login/index.dart';
import 'package:tipot/Login/utils/app_enum.dart';

import 'package:flutter/material.dart';

class CustomtextField extends StatefulWidget {
  CustomtextField({
    Key? key,
    required this.textController,
    required this.textfieldtype,
  });

  TextEditingController textController = TextEditingController();
  TextFieldType textfieldtype;

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
        SizedBox(height: 8),
        Align(
            alignment: Alignment.topLeft,
            child: Text(getLabelText(widget.textfieldtype),
                style: TextStyle(color: Colors.grey, fontSize: 10))),
        SizedBox(height: 8),
        TextFormField(
          controller: widget.textController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(31, 244, 189, 189),
            focusColor: Colors.amber,
            hintText: getHintText(widget.textfieldtype),
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
