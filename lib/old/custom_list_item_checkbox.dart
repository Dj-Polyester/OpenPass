import 'package:flutter/material.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/api/custom_list_item.dart';
import 'package:provider/provider.dart';

class CustomListItemCheckbox extends StatelessWidget {
  const CustomListItemCheckbox({Key? key, required this.mapKey})
      : super(key: key);

  final String mapKey;

  @override
  Widget build(BuildContext context) {
    return Selector<GlobalModel, bool>(
      selector: (_, globalModel) => globalModel.checkboxFlag,
      builder: (context, _, __) => Checkbox(
        value: context.read<CustomListModel>().selectedItems[mapKey],
        onChanged: (bool? value) {
          context.read<CustomListItemModel>().setCheckbox(value!);
        },
      ),
    );
  }
}
