import 'package:flutter/material.dart';
import 'package:polipass/widgets/api/azitem.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:provider/provider.dart';

import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';

class CustomListItemModel extends ChangeNotifier {
  CustomListItemModel(
    Locator read, {
    required this.string,
  }) {
    globalModel = read<GlobalModel>();
    customListModel = read<CustomListModel>();
    customPageModel = read<CustomPageModel>();
  }
  late GlobalModel globalModel;
  late CustomListModel customListModel;
  late CustomPageModel customPageModel;

  final String string;

  bool expand = false;

  void toggleExpansion() {
    expand = !expand;
    notifyListeners();
  }

  void expandListItem() {
    expand = true;
    notifyListeners();
  }

  void shrinkListItem() {
    expand = false;
    notifyListeners();
  }

  void setCheckbox(bool value) {
    customListModel.updateSelectedItems(string, value);

    if (value) {
      customListModel.incSelectedNum();
    } else {
      customListModel.decSelectedNum();
    }

    customListModel.setListTitleNotified();

    // print("custom_list_item: ${customListModel.selectedItems}");

    customListModel.setListTitle();
    globalModel.notifyCheckbox();
  }

  void toggleCheckbox() {
    bool value = customListModel.toggleSelectedItems(string);

    if (value) {
      customListModel.incSelectedNum();
    } else {
      customListModel.decSelectedNum();
    }

    customListModel.setListTitleNotified();

    // print("custom_list_item: ${customListModel.selectedItems}");

    customListModel.setListTitle();
    globalModel.notifyCheckbox();
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.azItem,
    required this.string,
    required this.customListItemView,
    this.trailing,
  }) : super(key: key);

  final Widget? trailing;
  final AZItem azItem;
  final String string;
  final Function customListItemView;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: true,
      create: (context) => CustomListItemModel(
        context.read,
        string: string,
      ),
      child: Selector<CustomListModel, bool>(
        selector: (_, customListModel) => customListModel.itemSelectVisible,
        builder: (context, itemSelectVisible, __) =>
            Selector<GlobalModel, bool>(
          selector: (_, globalModel) => globalModel.checkboxFlag,
          builder: (context, _, __) => Column(
            children: [
              Visibility(
                visible: azItem.isShowSuspension,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Globals.sidePadding,
                    right: Globals.sidePadding,
                    top: 2.0,
                    bottom: 2.0,
                  ),
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        azItem.getSuspensionTag(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
              ListTile(
                selected: (itemSelectVisible)
                    ? context.read<CustomListModel>().selectedItems[string]!
                    : false,
                onLongPress: () {
                  // context.read<CustomListModel>().turnOffSearchVisibility();
                  context.read<CustomListModel>().toggleSelectVisibility();
                  context.read<CustomListItemModel>().setCheckbox(true);
                },
                onTap: () {
                  context.read<CustomListItemModel>().toggleCheckbox();
                  if (!context.read<CustomListModel>().itemSelectVisible) {
                    context.read<CustomListItemModel>().toggleExpansion();
                  }
                },
                leading: Icon(
                  Icons.vpn_key,
                  color: Theme.of(context).iconTheme.color,
                ),
                trailing: trailing,
                title: customListItemView(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
