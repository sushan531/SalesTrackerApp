import 'package:get/get.dart';
import 'package:tipot/Login/utils/app_enum.dart';

mixin CustomTextFieldMixin {
  String? isValid(TextFieldType type, dynamic value, {String? password}) {
    String? validationErrorText = "";
    switch (type) {


      case TextFieldType.isEmail:
        validationErrorText = _validateEmail(value);

      case TextFieldType.isorganizationid:
        validationErrorText = _validateOraganizationName(value);
      case TextFieldType.ispassword:
        validationErrorText =_validatePassword(value);
        break;

      default:
        validationErrorText = "";
        break;
    }
    return validationErrorText;
  }

  String? _validateEmail(String? value) {
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit';
    }
    return null;
  }
  String? _validateOraganizationName(String? value) {
    if (value == null || value.isEmpty) {
      'Please enter Organization Name';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Organization Name must contain only alphabets and numbers';
    }
  }

// .
//   TextInputType getKeyboardType(TextFieldType type) {
//     TextInputType keyboardType;
//     switch (type) {
//       case TextFieldType.isclientId:
//       case TextFieldType.isuserId:
//       case TextFieldType.ispassword:
//         keyboardType = TextInputType.visiblePassword;
//       case TextFieldType.isnumber:
//         keyboardType = TextInputType.number;

//       default:
//         keyboardType = TextInputType.text;
//         break;
//     }
//     return keyboardType;
//   }

  String getHintText(TextFieldType type) {
    String? hintText;
    switch (type) {

      case TextFieldType.isEmail:
        hintText = "Email";
        break;
      case TextFieldType.ispassword:
        hintText = "Password";
        break;

      case TextFieldType.isorganizationid:
        hintText = "Organization ID";
        break;

      default:
        hintText = "";
        break;
    }
    return hintText;
  }

  String getLabelText(TextFieldType type) {
    String? LabelText;
    switch (type) {

      case TextFieldType.isEmail:
        LabelText = "Email";
        break;
      case TextFieldType.ispassword:
        LabelText = "Password";
        break;

      case TextFieldType.isorganizationid:
        LabelText = "Organization ID";
        break;

      default:
        LabelText = "";
        break;
    }
    return LabelText;
  }
}
