import 'package:flutter/material.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault.dart';
import 'package:polipass/widgets/custom_animated_size.dart';
import 'package:polipass/widgets/custom_list.dart';
import 'package:polipass/widgets/custom_list_item_checkbox.dart';
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

    print("custom_list_item: ${customListModel.selectedItems}");

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

    print("custom_list_item: ${customListModel.selectedItems}");

    customListModel.setListTitle();
    globalModel.notifyCheckbox();
  }
}

// class CustomListItem extends StatelessWidget {
//   const CustomListItem({
//     Key? key,
//     required this.passkey,
//     required this.customListItemView,
//   }) : super(key: key);

//   final Function customListItemView;

//   final PassKey passkey;
//   final Color borderColor = const Color(0xFFCCCCCC),
//       backgroundColor = const Color(0xFFEEEEEE),
//       splashColor = const Color(0xFFDDDDDD);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       lazy: true,
//       create: (context) => CustomListItemModel(
//         context.read,
//         passkey: passkey,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: borderColor),
//           borderRadius:
//               const BorderRadius.all(Radius.circular(Globals.itemsPaddingMax)),
//         ),
//         margin: const EdgeInsets.only(bottom: Globals.itemsSpacing),
//         child: ClipRRect(
//           borderRadius:
//               const BorderRadius.all(Radius.circular(Globals.itemsPaddingMax)),
//           child: Material(
//             color: backgroundColor,
//             child: Selector<CustomListModel, bool>(
//               selector: (_, customListModel) =>
//                   customListModel.itemSelectVisible,
//               builder: (context, itemSelectVisible, __) => InkWell(
//                 onLongPress: () {
//                   context.read<CustomListModel>().toggleVisibility();
//                   context.read<CustomListItemModel>().setCheckbox(true);
//                 },
//                 onTap: () {
//                   context.read<CustomListItemModel>().toggleExpansion();
//                 },
//                 splashColor: splashColor,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     CustomAnimatedSize(
//                       child: Visibility(
//                         visible: itemSelectVisible,
//                         child: CustomListItemCheckbox(mapKey: passkey.desc),
//                       ),
//                     ),
//                     Expanded(child: customListItemView(context)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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
                    left: 10.0,
                    right: 30.0,
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
                // CustomAnimatedSize(
                //   child: Visibility(
                //     visible: itemSelectVisible,
                //     child: CustomListItemCheckbox(mapKey: passkey.desc),
                //   ),
                // ),
                title: customListItemView(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
