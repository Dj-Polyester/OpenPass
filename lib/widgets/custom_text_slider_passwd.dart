import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text_slider.dart';
import 'package:polipass/widgets/custom_text_style.dart';

class CustomTextSliderPasswdWithProvider extends StatelessWidget {
  CustomTextSliderPasswdWithProvider({
    Key? key,
    this.validator,
    this.labelText = "",
    this.hintText = "",
    this.text = "",
    this.min = 0,
    this.max = 99,
    this.value = 0,
  }) : super(key: key);

  String? Function(String?)? validator;

  final String labelText, hintText, text;
  final double min, max, value;
  late double sliderValue = value;

  late CustomSliderModel sliderModel = CustomSliderModel(value: value);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: sliderModel,
      builder: (context, _) {
        // sliderValue = context.watch<CustomSliderModel>().value;
        return CustomTextSliderPasswd(
          text: text,
          min: min,
          max: max,
          validator: validator,
          labelText: labelText,
          hintText: hintText,
        );
      },
    );
  }
}

class CustomTextSliderPasswd extends StatelessWidget {
  CustomTextSliderPasswd({
    Key? key,
    this.validator,
    this.labelText = "",
    this.hintText = "",
    this.text = "",
    this.min = 0,
    this.max = 99,
  }) : super(key: key);
  String? Function(String?)? validator;
  final String labelText, hintText, text;
  double min, max;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: CustomTextStyle.textFieldStyle(
              labelTextStr: labelText,
              hintTextStr: hintText,
            ),
            controller: controller,
            validator: validator,
            onChanged: (String value) {
              context
                  .read<CustomSliderModel>()
                  .setVal(controller.text.length.toDouble());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextSlider(
            text: text,
            min: min,
            max: max,
            value: context.watch<CustomSliderModel>().value,
          ),
        ),
      ],
    );
  }
}
