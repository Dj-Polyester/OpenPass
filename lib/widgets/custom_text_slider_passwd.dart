import 'package:polipass/widgets/custom_text.dart';
import 'package:polipass/widgets/custom_text_digit.dart';
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

  late CustomSliderModel sliderModel = CustomSliderModel(value: value);
  late CustomTextDigitModel textDigitModel = CustomTextDigitModel(value: value);
  late CustomTextModel textPasswdModel = CustomTextModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sliderModel),
        ChangeNotifierProvider.value(value: textDigitModel),
        ChangeNotifierProvider.value(value: textPasswdModel),
      ],
      builder: (context, _) {
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
    this.value = 0,
  }) : super(key: key);
  String? Function(String?)? validator;
  final String labelText, hintText, text;
  double min, max, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextPasswd(
            validator: validator,
            labelText: labelText,
            hintText: hintText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextSlider(
            text: text,
            min: min,
            max: max,
          ),
        ),
      ],
    );
  }
}
