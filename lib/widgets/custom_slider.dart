import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSliderModel extends ChangeNotifier {
  CustomSliderModel({this.value = 0});
  double value;
  void setVal(double val) {
    value = val;
    notifyListeners();
  }
}

class CustomSlider extends StatelessWidget {
  CustomSlider({
    Key? key,
    this.min = 0,
    this.max = 99,
    this.controller,
  }) : super(key: key);

  final double min, max;

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: context.watch<CustomSliderModel>().value,
      min: min,
      max: max,
      divisions: max.toInt() - min.toInt(),
      label: context.watch<CustomSliderModel>().value.round().toString(),
      onChanged: (double val) {
        context.read<CustomSliderModel>().setVal(val);
        if (controller != null) {
          controller!.text =
              context.read<CustomSliderModel>().value.round().toString();
        }
      },
    );
  }
}
