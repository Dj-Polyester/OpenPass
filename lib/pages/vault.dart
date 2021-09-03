import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/screens/passwd_screen.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_list_item.dart';
import 'package:polipass/widgets/custom_list_item_view.dart';
import 'package:polipass/widgets/passkey_entry.dart';
import 'package:provider/provider.dart';

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

class Vault extends CustomPage {
  Vault()
      : super(
          appbar: (BuildContext context) => AppBar(
            title: Text(context.select(
              (CustomPageModel customPageModel) => customPageModel.currTitle!,
            )),
          ),
          body: _bodyBuilder,
          fab: _fabBuilder,
        );

  static Widget _bodyBuilder(BuildContext context) => ValueListenableBuilder(
      valueListenable: KeyStore.passkeys.listenable(),
      builder: (context, Box<PassKey> box, _) {
        List<PassKey> passkeys = box.values.toList().cast<PassKey>();

        return ListView.builder(
          padding: const EdgeInsets.all(Globals.itemsPaddingMax),
          itemCount: passkeys.length,
          itemBuilder: (BuildContext context, int i) {
            PassKey passkey = passkeys[i];

            return Selector<CustomPageModel, Map>(
              selector: (_, customPageModel) => customPageModel.selectedItems,
              builder: (_, selectedItems, __) => CustomListItem(
                selected: selectedItems[passkey.desc] ?? false,
                passkey: passkey,
                customListItemView: (BuildContext context) => PassKeyItemView(
                    passkey: context.select(
                        (CustomListItemModel customListItemModel) =>
                            customListItemModel.passkey)),
              ),
            );
          },
        );
      });

  static Widget _fabBuilder(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          await _dialogBuilder(context);
        },
        child: const Icon(Icons.add),
        tooltip: "Add a password",
      );

  static Future<void> _dialogBuilder(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) => PasswdScreen(),
    );
  }
}
