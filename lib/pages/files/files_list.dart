import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/custom_file.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/azitem.dart';
import 'package:polipass/widgets/api/custom_divider.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/api/custom_list_item.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FilesList extends StatelessWidget {
  const FilesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<GlobalModel, Tuple2>(
      selector: (_, globalModel) =>
          Tuple2(globalModel.searchStr, globalModel.listFlag),
      builder: (_, tuple, __) => FutureBuilder<List<FileSystemEntity>>(
        future: CustomFile.listFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null &&
              snapshot.hasData) {
            List<String> files = snapshot.data!
                .map((FileSystemEntity file) => path.basename(file.path))
                .where((String string) =>
                    string.endsWith(".${Globals.fileExtension}"))
                .map((String string) => string.split(".")[0])
                .toList();

            if (files.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Icon(
                        Icons.file_present,
                        size: Globals.emptyIconSize,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        Lang.tr(
                            "You do not have any key files. Please click the add button below to add files."),
                        style: TextStyle(
                            fontSize: context.select(
                                (GlobalModel globalModel) =>
                                    globalModel.fontSize)),
                      ),
                    ),
                  ],
                ),
              );
            }

            List<String> filesRefined = files
                .where((String name) => name.startsWith(tuple.item1))
                .toList();

            Map<String, bool> selectedItems = {
              for (String name in filesRefined) name: false
            };

            context
                .read<CustomListModel>()
                .provide(context.read, selectedItems);

            List<AZItem> azItems = filesRefined
                .map((String name) =>
                    AZItem(title: name, tag: name[0].toUpperCase()))
                .toList();

            context.read<CustomListModel>().reset();

            SuspensionUtil.setShowSuspensionStatus(azItems);

            return AzListView(
              key: UniqueKey(),
              data: azItems,
              separatorBuilder: (_, __) => const CustomDivider(),
              padding: const EdgeInsets.only(bottom: 50),
              itemCount: filesRefined.length,
              itemBuilder: (BuildContext context, int i) {
                String name = filesRefined[i];
                AZItem azItem = azItems[i];

                return CustomListItem(
                  azItem: azItem,
                  string: name,
                  customListItemView: (BuildContext context) => Text(name),
                  trailing: IconButton(
                      tooltip: Lang.tr("Import"),
                      onPressed: () async {
                        await CustomFile.importFile(context, name);
                        context
                            .read<CustomListModel>()
                            .turnOffSelectVisibility();
                        context.read<GlobalModel>().selectedIndex =
                            Globals.vaultIndex;
                      },
                      icon: const Icon(Icons.import_export)),
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
                ),
                selectItemDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          return Center(
              child: SpinKitRing(color: Theme.of(context).primaryColor));
        },
      ),
    );
  }
}
