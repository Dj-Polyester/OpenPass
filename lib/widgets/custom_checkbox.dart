import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCheckboxWithProvider extends StatelessWidget {
  CustomCheckboxWithProvider({
    Key? key,
  }) : super(key: key);

  late CustomCheckboxModel checkboxModel = CustomCheckboxModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: checkboxModel,
      builder: (context, _) {
        return CustomCheckbox();
      },
    );
  }
}

class CustomCheckboxModel extends ChangeNotifier {
  bool value = true;
  void setVal(bool val) {
    value = val;
    notifyListeners();
  }
}

class CustomCheckbox extends StatelessWidget {
  CustomCheckbox({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  bool value = false;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: context.watch<CustomCheckboxModel>().value,
      onChanged: (bool? val) {
        context.read<CustomCheckboxModel>().setVal(val!);
        onChanged?.call(val);
      },
    );
  }
}
