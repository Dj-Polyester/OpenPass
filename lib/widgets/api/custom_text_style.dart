import 'package:flutter/material.dart';

///https://stackoverflow.com/a/57442397/10713877
class CustomTextStyle {
  static InputDecoration textFieldStyle({
    String labelTextStr = "",
    String hintTextStr = "",
    Color? fillColor,
    Color? focusColor,
    Color? hoverColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      fillColor: fillColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      contentPadding: EdgeInsets.all(12),
      labelText: labelTextStr,
      hintText: hintTextStr,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
