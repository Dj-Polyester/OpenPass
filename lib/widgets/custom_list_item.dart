import 'package:flutter/material.dart';
import 'package:polipass/models/passkey.dart';
import 'package:provider/provider.dart';

import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';

class CustomListItemModel extends ChangeNotifier {
  CustomListItemModel(
    Locator read, {
    required this.passkey,
  }) {
    globalModel = read<GlobalModel>();
    customPageModel = read<CustomPageModel>();
  }
  late GlobalModel globalModel;
  late CustomPageModel customPageModel;

  final PassKey passkey;

  void setCheckbox(bool value) {
    customPageModel.updateSelectedItems(passkey.desc, value);

    if (value) {
      customPageModel.incSelectedNum();
    } else {
      customPageModel.decSelectedNum();
    }

    //print(contactModel.currTitle);
    //print(contactListModel!.phones);
    //print(contactListModel!.selectedItems);
    customPageModel.currTitle = "Selected ${customPageModel.selectedNum}";
    notifyListeners();
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem({
    Key? key,
    required this.selected,
    required this.passkey,
    // required this.contactListItemView,
  }) : super(key: key) {
    //print("contact: $contact");
  }
  bool selected;

  // final Function contactListItemView;

  final PassKey passkey;
  final Color borderColor = const Color(0xFFCCCCCC),
      backgroundColor = const Color(0xFFEEEEEE),
      splashColor = const Color(0xFFDDDDDD);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: true,
      create: (context) => CustomListItemModel(
        context.read,
        passkey: passkey,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius:
              const BorderRadius.all(Radius.circular(Globals.itemsPadding)),
        ),
        margin: const EdgeInsets.only(bottom: Globals.contactSpacing),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.all(Radius.circular(Globals.itemsPadding)),
          child: Material(
            color: backgroundColor,
            child: Selector<CustomPageModel, bool>(
              selector: (_, customPageModel) =>
                  customPageModel.contactSelectVisible,
              builder: (context, contactSelectVisible, __) => InkWell(
                onLongPress: () {
                  //print("long pressed");
                  bool newCheckBoxValue =
                      context.read<CustomPageModel>().toggleVisibility();
                  if (newCheckBoxValue) {
                    Provider.of<CustomListItemModel>(context, listen: false)
                        .setCheckbox(true);
                  }
                },
                onTap: () {
                  // Navigator.pushNamed(context,
                  //     "/${Provider.of<CustomPageModel>(context, listen: false).title}",
                  //     arguments: {"command": "update", "contact": contact});
                },
                splashColor: splashColor,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Visibility(
                      visible: contactSelectVisible,
                      child: Checkbox(
                        value: selected,
                        onChanged: (bool? value) {
                          // print("change contactitem checkbox with $value");
                          Provider.of<CustomListItemModel>(
                            context,
                            listen: false,
                          ).setCheckbox(value!);
                        },
                      ),
                    ),
                    // contactListItemView(context),
                    Padding(
                      padding: const EdgeInsets.all(Globals.itemsPadding),
                      child: Text(passkey.desc),
                    ),
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
