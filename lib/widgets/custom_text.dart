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

class CustomTextPasswd extends StatelessWidget {
  CustomTextPasswd({
    Key? key,
    this.validator,
    this.labelText = "",
    this.hintText = "",
  }) : super(key: key);

  String? Function(String?)? validator;
  final String labelText, hintText;

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
      onChanged: (String value) {
        double tmpval =
            context.read<CustomTextModel>().controller.text.length.toDouble();
        context.read<CustomSliderModel>().setValue(tmpval);
        context.read<CustomTextDigitModel>().setTextFromDouble(tmpval);
      },
    );
  }
}
