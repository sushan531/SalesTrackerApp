import 'package:tipot/Login/utils/app_enum.dart';

mixin CustomTextFieldMixin {
  String? isValid(TextFieldType type, dynamic value, {String? password}) {
    String? validationErrorText = "";
    switch (type) {
      case TextFieldType.isName:
        validationErrorText = value != "" ? "" : "Please enter your Name";
      case TextFieldType.isEmail:
        validationErrorText = value != "" ? "" : "Please enter your email ";
      case TextFieldType.isnumber:
        validationErrorText =
            value != "" ? "" : "Please enter your Mobile No. ";
      case TextFieldType.isnewpassword:
        validationErrorText = value != "" ? "" : "Please enter password ";
      case TextFieldType.isconfirmpassword:
        validationErrorText = value != "" ? "" : "Please confirm password";
        break;

      default:
        validationErrorText = "";
        break;
    }
    return validationErrorText;
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
      case TextFieldType.isName:
        hintText = "Name";
        break;
      case TextFieldType.isEmail:
        hintText = "Email";
        break;
      case TextFieldType.isnewpassword:
        hintText = "Password";
        break;
      case TextFieldType.isconfirmpassword:
        hintText = "Confirm Password";
        break;
      case TextFieldType.isnumber:
        hintText = "Mobile No.";
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
      case TextFieldType.isName:
        LabelText = "Name";
        break;
      case TextFieldType.isEmail:
        LabelText = "Email";
        break;
      case TextFieldType.isnewpassword:
        LabelText = "Password";
        break;
      case TextFieldType.isconfirmpassword:
        LabelText = "Confirm Password";
        break;
      case TextFieldType.isnumber:
        LabelText = "Mobile No.";
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
