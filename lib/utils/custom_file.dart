import 'package:path/path.dart' as path;
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/pages/vault/dialogs/single_input_dialog.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';

class CustomFile {
  static Future<void> importFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [Globals.fileExtension],
    );
    if (result != null) {
      String filePath = result.files.first.path;

      File file = File(filePath);

      List jsonObject = json.decode(file.readAsStringSync());

      print(jsonObject);

      await KeyStore.fromJson(jsonObject);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Lang.tr(
            "Imported the file with the name %s",
            [path.basename(filePath)],
          )),
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
      late String appDocPath;
      if (Platform.isAndroid) {
        late Directory appDocPathDir1 =
            Directory("/storage/emulated/0/Documents");
        late Directory appDocPathDir2 =
            Directory("/storage/emulated/0/documents");

        if (appDocPathDir1.existsSync()) {
          appDocPath = appDocPathDir1.path;
        } else if (appDocPathDir2.existsSync()) {
          appDocPath = appDocPathDir2.path;
        }
      } else if (Platform.isIOS) {
        //TODO: implement ios
      } else if (Platform.isLinux) {
        //TODO: implement linux
      } else if (Platform.isWindows) {
        //TODO: implement windows
      } else if (Platform.isMacOS) {
        //TODO: implement macos
      }
      String fullFilename = "$filename.${Globals.fileExtension}";
      String savePath = path.join(appDocPath, fullFilename);

      print(savePath);

      File file = File(savePath);
      late String snackbarMsg;
      if (await file.exists()) {
        //cannot add the file
        snackbarMsg =
            "Cannot save the file to documents because a file with the same name exists";
      } else {
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
  }
}
