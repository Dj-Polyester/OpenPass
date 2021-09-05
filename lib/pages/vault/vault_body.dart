import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_animated_size.dart';

import 'package:polipass/widgets/custom_list.dart';
import 'package:polipass/widgets/custom_list_item.dart';
import 'package:polipass/widgets/custom_list_item_view.dart';
import 'package:polipass/widgets/custom_text.dart';

import 'package:provider/provider.dart';

class VaultBody extends StatelessWidget {
  VaultBody({Key? key}) : super(key: key);

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
