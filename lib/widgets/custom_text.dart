import 'package:polipass/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text_style.dart';

class CustomText extends StatelessWidget {
  CustomText({
    Key? key,
    this.max = 99,
    required this.text,
    this.value = 0,
  }) : super(key: key);

  final String text;
  final double max;
  final double value;

  late TextEditingController controller =
      TextEditingController(text: value.round().toString());

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: max.round().toString().length,
      decoration: CustomTextStyle.textFieldStyle(labelTextStr: text),
      controller: controller,
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
