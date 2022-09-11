import 'package:flutter/material.dart';

// Colors
const kPrimaryColor = Color(0xFFFF97B3);

const kSecondaryLightColor = Color(0xFFE4E9F2);
const kSecondaryDarkColor = Color(0xFF404040);

const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);

const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

// Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kDateOfBirthNullError = "Please Enter your date of birth";
const String kTitleNullError = "Please Enter your title of task";
const String kNoteNullError = "Please Enter your note of task";

// Validators
String? emailValidator(String? value) {
  if (value!.isEmpty) {
    return kEmailNullError;
  } else if (!emailValidatorRegExp.hasMatch(value)) {
    return kInvalidEmailError;
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kPassNullError);
    return kPassNullError;
  } else if (value.length < 8) {
    // addError(error: kShortPassError);
    return kShortPassError;
  }
  return null;
}

String? confirmPasswordValidator(String? value, String? password) {
  if (value!.isEmpty) {
    return kPassNullError;
  } else if (password != value) {
    // addError(error: kMatchPassError);
    return kMatchPassError;
  }
  return null;
}

String? dobValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kDateOfBirthNullError);
    return kDateOfBirthNullError;
  }
  return null;
}

String? addressValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kAddressNullError);
    return kAddressNullError;
  }
  return null;
}

String? phoneNumberValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kPhoneNumberNullError);
    return kPhoneNumberNullError;
  }
  return null;
}

String? fullNameValidator(String? value) {
  if (value!.isEmpty) {
    // addError(error: kNamelNullError);
    return kNamelNullError;
  }
  return null;
}

String? titleValidator(String? value) {
  if (value!.isEmpty) {
    return kTitleNullError;
  }
  return null;
}

String? noteValidator(String? value) {
  if (value!.isEmpty) {
    return kNoteNullError;
  }
  return null;
}

// String to Color
Color HexColor(String hexColor) => new Color(int.parse(hexColor, radix: 16));

// Show snackBar
void showSnackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          width: MediaQuery.of(context).size.width * 95 / 100,
          content: Text(text, textAlign: TextAlign.justify),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      );
