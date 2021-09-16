import 'dart:async';

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

class CustomFile {
  //https://stackoverflow.com/a/17081903/10713877
  static Future<List<FileSystemEntity>>? listFiles() async {
    Directory dir = await getApplicationDocumentsDirectory();
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: false);
    lister.listen((file) => files.add(file),
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  static Future<void> importFile(BuildContext context, String name) async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      String filePath = path.join(
          (await getApplicationDocumentsDirectory()).path,
          "$name.${Globals.fileExtension}");

      File file = File(filePath);

      List jsonObject = json.decode(file.readAsStringSync());

      await KeyStore.passkeys.clear();
      await KeyStore.fromJson(jsonObject);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Lang.tr(
            "Imported the file with the name %s",
            [path.basename(filePath)],
          )),
        ),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
        String? appDoc = (await getApplicationDocumentsDirectory()).path;

        if (appDoc != null) {
          String fullFilename = "$filename.${Globals.fileExtension}";
          String savePath = path.join(appDoc, fullFilename);

          print(savePath);

          File file = File(savePath);
          late String snackbarMsg;
          if (await file.exists()) {
            //cannot add the file
            snackbarMsg =
                "Cannot save the file to documents because a file with the same name exists";
          } else {
            // await file.create();
            String jsonStr = json.encode(KeyStore.toJson());
            file.writeAsString(jsonStr);
            snackbarMsg = "Saved the file with the name %s to documents";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Lang.tr(
                  snackbarMsg,
                  [fullFilename],
                ),
              ),
            ),
          );
        }
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
