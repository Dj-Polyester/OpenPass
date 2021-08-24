import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCheckboxModel extends ChangeNotifier {
  bool value = false;
  void setVal(bool val) {
    value = val;
    notifyListeners();
  }
}

class CustomCheckbox extends StatelessWidget {
  CustomCheckbox({
    Key? key,
  }) : super(key: key);

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: context.watch<CustomCheckboxModel>().value,
      onChanged: (bool? val) {
        context.read<CustomCheckboxModel>().setVal(val!);
      },
    );
  }
}
