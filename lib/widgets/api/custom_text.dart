import 'package:polipass/widgets/api/custom_slider.dart';
import 'package:polipass/widgets/api/custom_text_digit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/widgets/api/custom_text_style.dart';

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
    this.textStyle,
    this.isSecret = false,
  }) : super(key: key);

  bool isSecret;

  TextStyle? textStyle;
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
            textStyle: textStyle,
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
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  Widget? prefixIcon, suffixIcon;
  TextStyle? textStyle;

  String? Function(String?)? validator;
  final String labelText, hintText;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textStyle,
      decoration: CustomTextStyle.textFieldStyle(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
