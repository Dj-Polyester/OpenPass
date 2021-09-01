import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text_digit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_text_style.dart';

class CustomTextModel extends ChangeNotifier {
  CustomTextModel({this.cursorPos = 0, String? text})
      : controller = TextEditingController(text: text);

  late TextEditingController controller;
  late FocusNode focusNode = FocusNode();

  int cursorPos;

  void setText(String text) {
    controller.text = text;
    setCursorPos();
  }

  void saveCursorPos() {
    cursorPos = controller.selection.baseOffset;
  }

  void setCursorPos() {
    controller.selection =
        TextSelection.fromPosition(TextPosition(offset: cursorPos));
  }
}

class CustomText extends StatelessWidget {
  CustomText({
    Key? key,
    this.validator,
    this.labelText = "",
    this.hintText = "",
    this.onChanged,
  }) : super(key: key);

  String? Function(String?)? validator;
  final String labelText, hintText;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: CustomTextStyle.textFieldStyle(
        labelTextStr: labelText,
        hintTextStr: hintText,
      ),
      controller: context.read<CustomTextModel>().controller,
      focusNode: context.read<CustomTextModel>().focusNode,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
