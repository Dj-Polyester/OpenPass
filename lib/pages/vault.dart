import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/screens/passwd_screen.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_animated_size.dart';
import 'package:polipass/widgets/custom_appbar_checkbox.dart';
import 'package:polipass/widgets/custom_list.dart';
import 'package:polipass/widgets/custom_list_item_checkbox.dart';
import 'package:polipass/widgets/custom_list_item.dart';
import 'package:polipass/widgets/custom_list_item_view.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:polipass/widgets/passkey_entry.dart';
import 'package:provider/provider.dart';
import 'package:polipass/widgets/custom_appbar.dart';

class AZItem extends ISuspensionBean {
  AZItem({
    required this.title,
    required this.tag,
  });

  final String title, tag;

  @override
  String getSuspensionTag() => tag;
}

class VaultDialogModel extends ChangeNotifier {
  VaultDialogModel({this.settingsHeightMax = 400})
      : settingsHeight = settingsHeightMax;
  final double settingsHeightMax;
  double settingsHeight;

  bool isSettingsVisible = false;
  void toggleVisibility() {
    isSettingsVisible = !isSettingsVisible;
    settingsHeight = (settingsHeight == 0) ? settingsHeightMax : 0;
    notifyListeners();
  }

  String currForm = "submit";
  void setCurrForm(String val) {
    currForm = val;
    notifyListeners();
  }
}

class _VaultBody extends StatelessWidget {
  _VaultBody({Key? key}) : super(key: key);

  CustomTextWithProvider searchWidget(BuildContext context) =>
      CustomTextWithProvider(
        labelText: "Search",
        hintText: "Search",
        onChanged: (String value) {
          context.read<GlobalModel>().notifySearch(value);
        },
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAnimatedSize(
          alignment: Alignment.topCenter,
          child: Visibility(
            visible: context.select((CustomListModel customListModel) =>
                customListModel.itemSearchVisible),
            child: Container(
              // decoration: BoxDecoration(color: Colors.blue),
              padding: const EdgeInsets.all(8.0),
              child: searchWidget(context),
            ),
          ),
        ),
        Expanded(
          child: Selector<GlobalModel, String>(
            selector: (_, globalModel) => globalModel.searchStr,
            builder: (_, searchStr, __) => ValueListenableBuilder<Box<PassKey>>(
              valueListenable: KeyStore.passkeys.listenable(),
              builder: (context, box, _) {
                List<PassKey> passkeys = box.values.toList();
                List<PassKey> passkeysRefined = passkeys
                    .where(
                        (PassKey passkey) => passkey.desc.startsWith(searchStr))
                    .toList();

                Map<String, bool> selectedItems = {
                  for (PassKey passkey in passkeysRefined) passkey.desc: false
                };

                context
                    .read<CustomListModel>()
                    .provide(context.read, selectedItems);

                List<AZItem> azItems = passkeysRefined
                    .map((PassKey passkey) => AZItem(
                        title: passkey.desc,
                        tag: passkey.desc[0].toUpperCase()))
                    .toList();

                print(selectedItems);

                context.read<CustomListModel>().reset();

                SuspensionUtil.setShowSuspensionStatus(azItems);
                return AzListView(
                  key: UniqueKey(),
                  data: azItems,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Colors.black54,
                    indent: Globals.sidePadding,
                    endIndent: Globals.sidePadding,
                  ),
                  padding: const EdgeInsets.only(bottom: 50),
                  itemCount: passkeysRefined.length,
                  itemBuilder: (BuildContext context, int i) {
                    PassKey passkey = passkeysRefined[i];
                    AZItem azItem = azItems[i];

                    return PassKeyListItem(
                      azItem: azItem,
                      passkey: passkey,
                      customListItemView: (BuildContext context) =>
                          PassKeyItemView(
                        passkey: context.select(
                            (CustomListItemModel customListItemModel) =>
                                customListItemModel.passkey),
                      ),
                    );

                    // return CustomListItem(
                    //   passkey: passkey,
                    //   customListItemView: (BuildContext context) => PassKeyItemView(
                    //       passkey: context.select(
                    //           (CustomListItemModel customListItemModel) =>
                    //               customListItemModel.passkey)),
                    // );
                  },
                  indexHintBuilder: (context, hint) => Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    width: 60,
                    height: 60,
                    child: Text(
                      hint,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  indexBarOptions: const IndexBarOptions(
                    needRebuild: true,
                    indexHintAlignment: Alignment.centerRight,
                    selectTextStyle: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                    ),
                    selectItemDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Vault extends CustomPage {
  Vault()
      : super(
          appbar: _appbarBuilder,
          body: _bodyBuilder,
          fab: _fabBuilder,
          hasList: true,
        );

  static Widget _appbarBuilder(BuildContext context) => CustomAppbar(
        invisibleActions: [
          Builder(
            builder: (context) => IconButton(
              tooltip: "delete from vault",
              icon: const Icon(Icons.delete),
              onPressed: () {
                Iterable<String> keys = context
                    .read<CustomListModel>()
                    .selectedItems
                    .entries
                    .where((element) => element.value)
                    .map((e) => e.key);
                print(keys);

                KeyStore.passkeys.deleteAll(keys);
                context.read<CustomListModel>().turnOffSelectVisibility();
                context.read<GlobalModel>().notifyHive();
              },
            ),
          ),
        ],
        visibleActions: [
          // IconButton(
          //   tooltip: "sort",
          //   onPressed: () {},
          //   icon: const Icon(Icons.sort),
          // ),
          IconButton(
            tooltip: "Search",
            onPressed: () {
              context.read<CustomListModel>().toggleSearchVisibility();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      );

  static Widget _bodyBuilder(BuildContext context) => _VaultBody();

  static Widget _fabBuilder(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          await dialogBuilder(context);
        },
        child: const Icon(Icons.add),
        tooltip: "Add a password",
      );

  static Future<void> dialogBuilder(BuildContext context,
      {PassKey? passkey}) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) => PasswdScreen(globalPasskey: passkey),
    );
  }
}
