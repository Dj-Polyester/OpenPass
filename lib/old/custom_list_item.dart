import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/api/custom_animated_size.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/api/custom_list_item.dart';
import 'package:polipass/old/custom_list_item_checkbox.dart';
import 'package:provider/provider.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.string,
    required this.customListItemView,
  }) : super(key: key);

  final Function customListItemView;

  final String string;
  final Color borderColor = const Color(0xFFCCCCCC),
      backgroundColor = const Color(0xFFEEEEEE),
      splashColor = const Color(0xFFDDDDDD);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: true,
      create: (context) => CustomListItemModel(
        context.read,
        string: string,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius:
              const BorderRadius.all(Radius.circular(Globals.itemsPaddingMax)),
        ),
        margin: const EdgeInsets.only(bottom: Globals.itemsSpacing),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.all(Radius.circular(Globals.itemsPaddingMax)),
          child: Material(
            color: backgroundColor,
            child: Selector<CustomListModel, bool>(
              selector: (_, customListModel) =>
                  customListModel.itemSelectVisible,
              builder: (context, itemSelectVisible, __) => InkWell(
                onLongPress: () {
                  context.read<CustomListModel>().toggleSelectVisibility();
                  context.read<CustomListItemModel>().setCheckbox(true);
                },
                onTap: () {
                  context.read<CustomListItemModel>().toggleExpansion();
                },
                splashColor: splashColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomAnimatedSize(
                      child: Visibility(
                        visible: itemSelectVisible,
                        child: CustomListItemCheckbox(mapKey: string),
                      ),
                    ),
                    Expanded(child: customListItemView(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
