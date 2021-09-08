import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_animated_size.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/custom_list_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/globals.dart';
import 'package:tuple/tuple.dart';

class _TextFieldCreds extends StatelessWidget {
  const _TextFieldCreds({
    Key? key,
    this.text,
    this.fontSize,
    this.obscureText = false,
  }) : super(key: key);

  final String? text;
  final double? fontSize;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: TextField(
          obscureText: obscureText,
          style: TextStyle(
            fontSize: fontSize,
          ),
          readOnly: true,
          controller: TextEditingController(text: text),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8.0),
            isCollapsed: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }
}

class _PassKeyItemViewCreds extends StatelessWidget {
  const _PassKeyItemViewCreds({Key? key, required this.item}) : super(key: key);

  final PassKeyItem item;

  String getTranslatedName(String text) {
    switch (text) {
      case "Description":
      case "Username":
      case "Email":
      case "Password":
        return Lang.tr(text);
      default:
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PassKeyItemModel(),
      child: Padding(
        padding: Globals.itemsPadding,
        child: Selector<GlobalModel, Tuple2>(
          selector: (_, globalModel) =>
              Tuple2(globalModel.fontSize, globalModel.fontSizeSmall),
          builder: (_, tuple, __) => Selector<PassKeyItemModel, bool>(
            selector: (_, passKeyItemModel) => passKeyItemModel.obscureSecret,
            builder: (context, obscureSecret, __) => Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: tuple.item2 * 5,
                  ),
                  child: Text(
                    getTranslatedName(item.name),
                    style: TextStyle(fontSize: tuple.item2),
                  ),
                ),
                _TextFieldCreds(
                  text: item.value,
                  fontSize: tuple.item2,
                  obscureText: (item.isSecret) ? obscureSecret : false,
                ),
                GestureDetector(
                  onLongPress: () {},
                  child: IconButton(
                    splashRadius: tuple.item1,
                    iconSize: tuple.item1,
                    tooltip: Lang.tr("Copy to clipboard"),
                    onPressed: () {},
                    icon: const Icon(Icons.copy),
                  ),
                ),
                Visibility(
                  visible: item.isSecret ? obscureSecret : false,
                  child: GestureDetector(
                    onLongPress: () {},
                    child: IconButton(
                      splashRadius: tuple.item1,
                      iconSize: tuple.item1,
                      tooltip: Lang.tr("Show"),
                      onPressed: () {
                        context.read<PassKeyItemModel>().showSecret();
                      },
                      icon: const Icon(Icons.visibility),
                    ),
                  ),
                ),
                Visibility(
                  visible: item.isSecret ? !obscureSecret : false,
                  child: GestureDetector(
                    onLongPress: () {},
                    child: IconButton(
                      splashRadius: tuple.item1,
                      iconSize: tuple.item1,
                      tooltip: Lang.tr("Hide"),
                      onPressed: () {
                        context.read<PassKeyItemModel>().hideSecret();
                      },
                      icon: const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PassKeyItemView extends StatelessWidget {
  const PassKeyItemView({
    Key? key,
    required this.passkey,
  }) : super(key: key);

  final PassKey passkey;

  @override
  Widget build(BuildContext context) {
    return Selector<GlobalModel, double>(
      selector: (_, globalModel) => globalModel.fontSize,
      builder: (_, fontSize, __) => ChangeNotifierProvider<PassKeyModel>(
        create: (_) => PassKeyModel(),
        builder: (context, _) => ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: Globals.passKeyItemViewMinHeight),
          child: Selector<CustomListItemModel, bool>(
            selector: (_, customListItemModel) => customListItemModel.expand,
            builder: (context, expand, __) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !expand,
                  child: Padding(
                    padding: Globals.itemsPadding,
                    child: Text(
                      passkey.desc,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ),
                ),
                CustomAnimatedSize(
                  child: Visibility(
                    visible: expand,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: passkey.items
                              .where((PassKeyItem item) => item.value != "")
                              .map(
                                (PassKeyItem item) =>
                                    _PassKeyItemViewCreds(item: item),
                              )
                              .toList()
                              .cast<Widget>() +
                          [
                            Center(
                              child: GestureDetector(
                                onLongPress: () {},
                                onTap: () {},
                                child: TextButton(
                                    onPressed: () async {
                                      if (!context
                                          .read<CustomListModel>()
                                          .itemSelectVisible) {
                                        await Vault.dialogBuilder(context,
                                            passkey: passkey);
                                      }
                                    },
                                    child: Text(Lang.tr("Update"))),
                              ),
                            )
                          ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
