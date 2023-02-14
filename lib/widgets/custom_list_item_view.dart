import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_animated_size.dart';
import 'package:polipass/widgets/api/custom_button.dart';
import 'package:polipass/widgets/api/custom_list.dart';
import 'package:polipass/widgets/api/custom_text.dart';
import 'package:polipass/widgets/api/custom_list_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/globals.dart';

class _TextFieldCreds extends StatelessWidget {
  _TextFieldCreds({
    Key? key,
    required this.text,
    required this.fontSize,
    this.isSecret = false,
  }) : super(key: key);

  final String text;
  double fontSize;
  final bool isSecret;

  @override
  Widget build(BuildContext context) {
    return Selector<PassKeyItemModel, bool>(
      selector: (_, passKeyItemModel) => passKeyItemModel.obscureSecret,
      builder: (context, obscureSecret, __) => Expanded(
        child: CustomTextWithProvider(
          inputText: text,
          obscureText: (isSecret) ? obscureSecret : false,
          textStyle: TextStyle(fontSize: fontSize),
          readOnly: true,
          isCollapsed: true,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onLongPress: () {},
                child: IconButton(
                  splashRadius: fontSize,
                  iconSize: fontSize,
                  tooltip: Lang.tr("Copy to clipboard"),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: text));
                    Fluttertoast.showToast(
                      msg: Lang.tr("Copied"),
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  },
                  icon: Icon(
                    Icons.copy,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Visibility(
                visible: isSecret ? obscureSecret : false,
                child: IconButton(
                  splashRadius: fontSize,
                  iconSize: fontSize,
                  tooltip: Lang.tr("Show"),
                  onPressed: () {
                    context.read<PassKeyItemModel>().showSecret();
                  },
                  icon: Icon(
                    Icons.visibility,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Visibility(
                visible: isSecret ? !obscureSecret : false,
                child: IconButton(
                  splashRadius: fontSize,
                  iconSize: fontSize,
                  tooltip: Lang.tr("Hide"),
                  onPressed: () {
                    context.read<PassKeyItemModel>().hideSecret();
                  },
                  icon: Icon(
                    Icons.visibility_off,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ],
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
        child: Selector<GlobalModel, double>(
          selector: (_, globalModel) => globalModel.fontSizeSmall,
          builder: (_, fontSizeSmall, __) => Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: fontSizeSmall * 5,
                ),
                child: Text(
                  getTranslatedName(item.name),
                  style: TextStyle(fontSize: fontSizeSmall),
                ),
              ),
              _TextFieldCreds(
                text: item.value,
                isSecret: item.isSecret,
                fontSize: fontSizeSmall,
              ),
            ],
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
              const BoxConstraints(minHeight: Globals.passKeyItemViewMinHeight),
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
                                child: SecondaryButton(
                                  onPressed: () async {
                                    if (!context
                                        .read<CustomListModel>()
                                        .itemSelectVisible) {
                                      await Vault.dialogBuilder(context,
                                          passkey: passkey);
                                    }
                                  },
                                  child: Text(
                                    Lang.tr("Update"),
                                  ),
                                ),
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
