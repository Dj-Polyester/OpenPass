// import 'db/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/api/custom_appbar_checkbox.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget {
  CustomAppbar({
    Key? key,
    this.invisibleActions = const [],
    this.visibleActions = const [],
  }) : super(key: key);

  Widget? title, leading;
  final List<Widget> invisibleActions, visibleActions;

  @override
  Widget build(BuildContext context) {
    return Selector<CustomPageModel, String?>(
      selector: (_, customPageModel) => customPageModel.currTitle,
      builder: (context, currTitle, __) => Selector<CustomListModel, bool>(
        selector: (_, customListModel) => customListModel.itemSelectVisible,
        builder: (context, itemSelectVisible, __) => AppBar(
          title: Text(currTitle!),
          leading: (itemSelectVisible) ? const CustomAppbarCheckbox() : null,
          actions: invisibleActions
                  .map(
                    (child) =>
                        Visibility(visible: itemSelectVisible, child: child),
                  )
                  .toList()
                  .cast<Widget>() +
              visibleActions,
        ),
      ),
    );
  }
}
