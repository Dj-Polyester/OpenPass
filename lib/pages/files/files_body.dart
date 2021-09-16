import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polipass/pages/files/files_list.dart';

import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_animated_size.dart';
import 'package:polipass/widgets/api/custom_list.dart';

import 'package:polipass/pages/vault/vault_list.dart';
import 'package:polipass/widgets/api/custom_text.dart';

import 'package:provider/provider.dart';

class FilesBody extends StatelessWidget {
  FilesBody({Key? key}) : super(key: key);

  CustomTextWithProvider searchWidget(BuildContext context) =>
      CustomTextWithProvider(
        onEditingComplete: () {
          context.read<CustomListModel>().turnOffSearchVisibility();
          context.read<GlobalModel>().notifySearch("");
        },
        labelText: Lang.tr("Search"),
        hintText: Lang.tr("Search"),
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
              padding: const EdgeInsets.all(8.0),
              child: searchWidget(context),
            ),
          ),
        ),
        const Expanded(child: FilesList())
      ],
    );
  }
}
