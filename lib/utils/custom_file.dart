import 'dart:async';

import 'package:polipass/models/globals.dart';
import 'package:polipass/pages/files/dialogs/confirmation_dialog.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/pages/vault/dialogs/single_input_dialog.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polipass/widgets/api/custom_snackbar.dart';

class CustomFile {
  static Directory? _filesDir;

  static Future<Directory> get filesDir async =>
      _filesDir ??
      (_filesDir = Directory((await getApplicationDocumentsDirectory()).path));

  //https://stackoverflow.com/a/17081903/10713877
  static Future<List<FileSystemEntity>>? listFiles() async {
    Directory dir = await filesDir;

    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  static Future<Confirmation> _confirmation(context) async =>
      (await showDialog<Confirmation>(
        context: context,
        builder: (context) => const ConfirmationDialog(
          title:
              "Your current configuration is not saved as a file yet. Overwrite?",
          yes: "Yes, overwrite",
          no: "No, I will save my configuration",
        ),
      )) ??
      Confirmation.no;

  static Future<void> importFile(BuildContext context, String name) async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      Directory dir = await filesDir;
      String filePath = path.join(dir.path, "$name.${Globals.fileExtension}");

      File file = File(filePath);

      List jsonObject =
          json.decode(await KeyStore.decrypt(file.readAsStringSync()));

      bool saved = context.read<PersistentGlobalsModel>().saved;

      if (saved ||
          (!saved && ((await _confirmation(context)) == Confirmation.yes))) {
        await KeyStore.passkeys.clear();
        await KeyStore.fromJson(jsonObject);
        context.read<PersistentGlobalsModel>().saved = true;

        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar(
            content: Text(Lang.tr(
              "Imported the file with the name %s",
              [path.basename(filePath)],
            )),
          ),
        );
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackbar(
          content: Text(Lang.tr("You need to allow access to the storage")),
        ),
      );
    }
  }

  static Future<void> exportFile(BuildContext context) async {
    String? filename = await showDialog<String>(
      context: context,
      builder: (_) => SingleInputDialog(),
    );
    if (filename != null) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        Directory dir = await filesDir;
        String fullFilename = "$filename.${Globals.fileExtension}";
        String savePath = path.join(dir.path, fullFilename);

        File file = File(savePath);
        late String snackbarMsg;
        if (await file.exists()) {
          //cannot add the file
          snackbarMsg =
              "Cannot save the file to documents because a file with the same name exists";
        } else {
          String jsonStr =
              await KeyStore.encrypt(json.encode(KeyStore.toJson()));
          file.writeAsString(jsonStr);
          //SAVE
          context.read<PersistentGlobalsModel>().saved = true;
          snackbarMsg = "Saved the file with the name %s";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar(
            content: Text(
              Lang.tr(
                snackbarMsg,
                [fullFilename],
              ),
            ),
          ),
        );
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackbar(
            content: Text(Lang.tr("You need to allow access to the storage")),
          ),
        );
      }
    }
  }

  static Future<void> deleteFiles(List<String> names) async {
    Directory dir = await getApplicationDocumentsDirectory();

    for (var name in names) {
      String filePath = path.join(dir.path, "$name.${Globals.fileExtension}");
      File file = File(filePath);
      file.deleteSync();
    }
  }
}
