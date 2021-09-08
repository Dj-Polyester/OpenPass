import 'package:flutter/material.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/api/azitem.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/custom_list.dart';
import 'package:provider/provider.dart';

import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';

class CustomListItemModel extends ChangeNotifier {
  CustomListItemModel(
    Locator read, {
    required this.passkey,
  }) {
    globalModel = read<GlobalModel>();
    customListModel = read<CustomListModel>();
    customPageModel = read<CustomPageModel>();
  }
  late GlobalModel globalModel;
  late CustomListModel customListModel;
  late CustomPageModel customPageModel;

  final PassKey passkey;

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
    customListModel.updateSelectedItems(passkey.desc, value);

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
    bool value = customListModel.toggleSelectedItems(passkey.desc);

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

class PassKeyListItem extends StatelessWidget {
  const PassKeyListItem({
    Key? key,
    required this.azItem,
    required this.passkey,
    required this.customListItemView,
  }) : super(key: key);

  final AZItem azItem;
  final PassKey passkey;
  final Function customListItemView;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: true,
      create: (context) => CustomListItemModel(
        context.read,
        passkey: passkey,
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
                        color: Colors.black12,
                      ),
                      child: Text(
                        azItem.getSuspensionTag(),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
              ListTile(
                selected: (itemSelectVisible)
                    ? context
                        .read<CustomListModel>()
                        .selectedItems[passkey.desc]!
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
                leading: const Icon(Icons.vpn_key),
                title: customListItemView(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
