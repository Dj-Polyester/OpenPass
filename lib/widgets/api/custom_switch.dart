import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSwitchWithProvider extends StatelessWidget {
  CustomSwitchWithProvider({
    Key? key,
  }) : super(key: key);

  late CustomSwitchModel checkboxModel = CustomSwitchModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: checkboxModel,
      builder: (context, _) {
        return CustomSwitch();
      },
    );
  }
}

class CustomSwitchModel extends ChangeNotifier {
  bool value = true;
  void setVal(bool val) {
    value = val;
    notifyListeners();
  }
}

class CustomSwitch extends StatelessWidget {
  CustomSwitch({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  bool value = false;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: context.watch<CustomSwitchModel>().value,
      onChanged: (bool? val) {
        context.read<CustomSwitchModel>().setVal(val!);
        onChanged?.call(val);
      },
    );
  }
}
