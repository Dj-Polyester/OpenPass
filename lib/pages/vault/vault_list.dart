import 'package:hive_flutter/hive_flutter.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/azitem.dart';
import 'package:polipass/widgets/api/custom_divider.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/custom_list_item.dart';
import 'package:polipass/widgets/custom_list_item_view.dart';
import 'package:provider/provider.dart';

class VaultList extends StatelessWidget {
  const VaultList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<GlobalModel, String>(
      selector: (_, globalModel) => globalModel.searchStr,
      builder: (_, searchStr, __) => ValueListenableBuilder<Box<PassKey>>(
        valueListenable: KeyStore.passkeys.listenable(),
        builder: (context, box, _) {
          List<PassKey> passkeys = box.values.toList();
          if (passkeys.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Icon(
                      Icons.vpn_key,
                      size: Globals.emptyIconSize,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      Lang.tr(
                          "Your Vault is Empty. Please click the add button below to add keys."),
                      style: TextStyle(
                          fontSize: context.select((GlobalModel globalModel) =>
                              globalModel.fontSize)),
                    ),
                  ),
                ],
              ),
            );
          }
          List<PassKey> passkeysRefined = passkeys
              .where((PassKey passkey) => passkey.desc.startsWith(searchStr))
              .toList();

          Map<String, bool> selectedItems = {
            for (PassKey passkey in passkeysRefined) passkey.desc: false
          };

          context.read<CustomListModel>().provide(context.read, selectedItems);

          List<AZItem> azItems = passkeysRefined
              .map((PassKey passkey) => AZItem(
                  title: passkey.desc, tag: passkey.desc[0].toUpperCase()))
              .toList();

          // print(selectedItems);

          context.read<CustomListModel>().reset();

          SuspensionUtil.setShowSuspensionStatus(azItems);
          return AzListView(
            key: UniqueKey(),
            data: azItems,
            separatorBuilder: (_, __) => const CustomDivider(),
            padding: const EdgeInsets.only(bottom: 50),
            itemCount: passkeysRefined.length,
            itemBuilder: (BuildContext context, int i) {
              PassKey passkey = passkeysRefined[i];
              AZItem azItem = azItems[i];

              return CustomListItem(
                azItem: azItem,
                string: passkey.desc,
                customListItemView: (BuildContext context) => PassKeyItemView(
                  passkey: passkey,
                ),
              );
            },
            indexHintBuilder: (context, hint) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
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
            indexBarOptions: IndexBarOptions(
              needRebuild: true,
              indexHintAlignment: Alignment.centerRight,
              selectTextStyle: const TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
              ),
              selectItemDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
