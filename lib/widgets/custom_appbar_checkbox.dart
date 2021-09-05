import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_list.dart';
import 'package:polipass/widgets/custom_list_item.dart';
import 'package:provider/provider.dart';

class CustomAppbarCheckbox extends StatelessWidget {
  const CustomAppbarCheckbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<CustomListModel, bool>(
      selector: (_, customListModel) => customListModel.checkboxValue,
      builder: (context, checkboxValue, __) => Tooltip(
        message: "Select all",
        child: Checkbox(
          value: checkboxValue,
          onChanged: (bool? value) {
            context.read<CustomListModel>().setCheckbox(value!);
          },
        ),
      ),
    );
  }
}
