import 'dart:convert';
import 'dart:io';
import 'package:azlistview/azlistview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/dialogs/single_input_dialog.dart';
import 'package:polipass/pages/vault/vault_body.dart';
import 'package:polipass/pages/vault/dialogs/vault_dialog.dart';
import 'package:polipass/utils/custom_file.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_list.dart';

import 'package:provider/provider.dart';
import 'package:polipass/widgets/api/custom_appbar.dart';

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
              tooltip: Lang.tr("Delete from vault"),
              icon: const Icon(Icons.delete),
              onPressed: () {
                Iterable<String> keys = context
                    .read<CustomListModel>()
                    .selectedItems
                    .entries
                    .where((element) => element.value)
                    .map((e) => e.key);
                // print(keys);

                KeyStore.passkeys.deleteAll(keys);
                context.read<CustomListModel>().turnOffSelectVisibility();
                context.read<GlobalModel>().notifyHive();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Lang.tr("Deleted the key sets from vault"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        visibleActions: [
          IconButton(
            tooltip: Lang.tr("Import"),
            onPressed: () async {
              await CustomFile.importFile(context);
            },
            icon: const Icon(Icons.arrow_downward),
          ),
          IconButton(
            tooltip: Lang.tr("Export"),
            onPressed: () async {
              await CustomFile.exportFile(context);
            },
            icon: const Icon(Icons.arrow_upward),
          ),
          IconButton(
            tooltip: Lang.tr("Search"),
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
        tooltip: Lang.tr("Add a key set"),
      );

  static Future<void> dialogBuilder(BuildContext context,
      {PassKey? passkey, Widget Function(BuildContext)? builder}) async {
    return await showDialog<void>(
      context: context,
      builder: builder ?? (_) => VaultDialog(globalPasskey: passkey),
    );
  }
}
