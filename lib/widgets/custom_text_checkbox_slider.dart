import 'package:flutter/material.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/custom_animated_size.dart';
import 'package:polipass/widgets/custom_checkbox.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text_digit.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_slider.dart';
import 'package:polipass/widgets/custom_text_style.dart';
import 'package:provider/provider.dart';

class CustomTextCheckboxSliderWithProvider extends StatelessWidget {
  CustomTextCheckboxSliderWithProvider({
    Key? key,
    required this.text1,
    required this.text2,
    required this.text3,
    this.min = 0,
    this.max = 99,
  }) : super(key: key);

  final String text1, text2, text3;
  final double min, max;

  late double sliderValue;
  late bool checkboxValue;

  late CustomCheckboxModel checkboxModel = CustomCheckboxModel();
  late CustomSliderModel sliderModel = CustomSliderModel();
  late CustomTextDigitModel textModel = CustomTextDigitModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: checkboxModel),
        ChangeNotifierProvider.value(value: sliderModel),
        ChangeNotifierProvider.value(value: textModel),
      ],
      builder: (context, _) {
        sliderValue = context.watch<CustomSliderModel>().value;
        checkboxValue = context.watch<CustomCheckboxModel>().value;

        return CustomTextCheckboxSlider(
          text1: text1,
          text2: text2,
          text3: text3,
          min: min,
          max: max,
        );
      },
    );
  }
}

class CustomTextCheckboxSlider extends StatelessWidget {
  CustomTextCheckboxSlider({
    Key? key,
    required this.text1,
    required this.text2,
    required this.text3,
    this.min = 0,
    this.max = 99,
    this.sliderValue = 0,
  }) : super(key: key);

  final String text1, text2, text3;
  final double min, max;
  double sliderValue;
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextCheckbox(
          text1: text1,
          text2: text2,
        ),
        CustomAnimatedSize(
          child: Visibility(
            visible: context.watch<CustomCheckboxModel>().value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextSlider(
                label: text3,
                min: min,
                max: max,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
