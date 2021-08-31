import 'package:polipass/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text_style.dart';

class CustomTextDigitModel extends ChangeNotifier {
  CustomTextDigitModel({this.cursorPos = 0, double value = 0})
      : controller = TextEditingController(text: value.round().toString()) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus && controller.text.isEmpty) {
        controller.text = "0";
      }
    });
  }

  late TextEditingController controller;
  late FocusNode focusNode = FocusNode();

  int cursorPos;

  void setTextFromDouble(double value) {
    controller.text = value.round().toString();
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

class CustomTextDigit extends StatelessWidget {
  CustomTextDigit({
    Key? key,
    this.max = 99,
    required this.text,
    this.value = 0,
  }) : super(key: key);

  final String text;
  final double max;
  final double value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: max.round().toString().length,
      decoration: CustomTextStyle.textFieldStyle(labelTextStr: text),
      controller: context.read<CustomTextDigitModel>().controller,
      focusNode: context.read<CustomTextDigitModel>().focusNode,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Empty';
        }
        return null;
      },
      onChanged: (String val) {
        late double tmpval;
        if (Globals.isNumeric(val)) {
          tmpval = double.parse(val);
        } else if (val.isEmpty) {
          tmpval = 0;
        }
        context.read<CustomSliderModel>().setValue(tmpval);
      },
    );
  }
}
