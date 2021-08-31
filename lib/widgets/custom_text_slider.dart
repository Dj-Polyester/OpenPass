import 'package:flutter/material.dart';
import 'package:polipass/pages/vault.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:polipass/widgets/custom_text_style.dart';
import 'package:provider/provider.dart';

class CustomTextSliderWithProvider extends StatelessWidget {
  CustomTextSliderWithProvider({
    Key? key,
    required this.text,
    this.min = 0,
    this.max = 99,
    this.value = 0,
  }) : super(key: key);

  final String text;
  final double min, max, value;
  late double sliderValue;

  late CustomSliderModel sliderModel = CustomSliderModel(value: value);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: sliderModel,
      builder: (context, _) {
        sliderValue = context.watch<CustomSliderModel>().value;
        return CustomTextSlider(
          text: text,
          min: min,
          max: max,
          value: sliderValue,
        );
      },
    );
  }
}

class CustomTextSlider extends StatelessWidget {
  CustomTextSlider({
    Key? key,
    this.min = 0,
    this.max = 99,
    required this.text,
    this.value = 0,
  }) : super(key: key);

  final String text;
  final double min, max;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Consumer<CustomSliderModel>(
            builder: (_, customSliderModel, __) => CustomText(
              text: text,
              max: max,
              value: customSliderModel.value,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: CustomSlider(
            min: min,
            max: max,
          ),
        ),
      ],
    );
  }
}
