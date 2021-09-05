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

class CustomTextWithProvider extends StatelessWidget {
  CustomTextWithProvider({
    Key? key,
    this.validator,
    this.labelText = "",
    this.hintText = "",
    this.inputText,
    this.onChanged,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
  }) : super(key: key);

  Color? fillColor, focusColor, hoverColor;
  String? inputText;
  String? Function(String?)? validator;
  Function(String)? onChanged;

  final String labelText, hintText;

  late CustomTextModel textModel = CustomTextModel(text: inputText);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: textModel),
      ],
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            validator: validator,
            labelText: labelText,
            hintText: hintText,
            onChanged: onChanged,
            fillColor: fillColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
          ),
        );
      },
    );
  }
}

class CustomText extends StatelessWidget {
  CustomText({
    Key? key,
    this.validator,
    this.labelText = "",
    this.hintText = "",
    this.onChanged,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
  }) : super(key: key);

  Color? fillColor, focusColor, hoverColor;

  String? Function(String?)? validator;
  final String labelText, hintText;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: CustomTextStyle.textFieldStyle(
        labelTextStr: labelText,
        hintTextStr: hintText,
        fillColor: fillColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
      ),
      controller: context.read<CustomTextModel>().controller,
      focusNode: context.read<CustomTextModel>().focusNode,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
