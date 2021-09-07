import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/api/custom_animated_size.dart';
import 'package:polipass/widgets/api/custom_list.dart';

import 'package:polipass/widgets/custom_list.dart';
import 'package:polipass/widgets/api/custom_text.dart';

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
        const Expanded(child: PasskeyList())
      ],
    );
  }
}
