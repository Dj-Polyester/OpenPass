import 'package:azlistview/azlistview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/vault_body.dart';
import 'package:polipass/pages/vault/vault_dialog.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/api/custom_list.dart';

import 'package:provider/provider.dart';
import 'package:polipass/widgets/api/custom_appbar.dart';

class AZItem extends ISuspensionBean {
  AZItem({
    required this.title,
    required this.tag,
  });

  final String title, tag;

  @override
  String getSuspensionTag() => tag;
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
          IconButton(
            tooltip: "Import",
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform
                  .pickFiles(allowedExtensions: [Globals.fileExtension]);
              print("paths: ${result!.paths}");
            },
            icon: const Icon(Icons.arrow_downward),
          ),
          IconButton(
            tooltip: "Export",
            onPressed: () {},
            icon: const Icon(Icons.arrow_upward),
          ),
          IconButton(
            tooltip: "Search",
            onPressed: () {
              context.read<CustomListModel>().toggleSearchVisibility();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      );

  static Widget _bodyBuilder(BuildContext context) => VaultBody();

  static Widget _fabBuilder(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          await dialogBuilder(context);
        },
        child: const Icon(Icons.add),
        tooltip: "Add a password",
      );

  static Future<void> dialogBuilder(BuildContext context,
      {PassKey? passkey, Widget Function(BuildContext)? builder}) async {
    return await showDialog<void>(
      context: context,
      builder: builder ?? (_) => VaultDialog(globalPasskey: passkey),
    );
  }
}
