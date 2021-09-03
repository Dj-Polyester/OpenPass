import 'package:polipass/widgets/custom_icon_btn.dart';
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
    return IntrinsicWidth(
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
    );
  }
}

class _PassKeyItemViewCreds extends StatelessWidget {
  const _PassKeyItemViewCreds({Key? key, required this.item}) : super(key: key);

  final Map item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Globals.itemsPadding,
      child: Selector<GlobalModel, Tuple2>(
        selector: (_, globalModel) =>
            Tuple2(globalModel.fontSize, globalModel.fontSizeSmall),
        builder: (_, tuple, __) => Consumer<PassKeyModel>(
          builder: (context, passKeyModel, __) => Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: tuple.item2 * 5,
                ),
                child: Text(
                  item["name"],
                  style: TextStyle(fontSize: tuple.item2),
                ),
              ),
              _TextFieldCreds(
                text: item["value"],
                fontSize: tuple.item2,
                obscureText: (item["isSecret"])
                    ? context.watch<PassKeyModel>().obscureSecret
                    : false,
              ),
              GestureDetector(
                onLongPress: () {},
                child: IconButton(
                  splashRadius: tuple.item1,
                  iconSize: tuple.item1,
                  tooltip: "copy to clipboard",
                  onPressed: () {},
                  icon: const Icon(Icons.copy),
                ),
              ),
              Visibility(
                visible: item["isSecret"] ? passKeyModel.obscureSecret : false,
                child: GestureDetector(
                  onLongPress: () {},
                  child: IconButton(
                    splashRadius: tuple.item1,
                    iconSize: tuple.item1,
                    tooltip: "show",
                    onPressed: () {
                      context.read<PassKeyModel>().showSecret();
                    },
                    icon: const Icon(Icons.visibility),
                  ),
                ),
              ),
              Visibility(
                visible: item["isSecret"] ? !passKeyModel.obscureSecret : false,
                child: GestureDetector(
                  onLongPress: () {},
                  child: IconButton(
                    splashRadius: tuple.item1,
                    iconSize: tuple.item1,
                    tooltip: "hide",
                    onPressed: () {
                      context.read<PassKeyModel>().hideSecret();
                    },
                    icon: const Icon(Icons.visibility_off),
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
          constraints: BoxConstraints(
            minHeight: 50,
          ),
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
                Visibility(
                  visible: expand,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: passkey.items
                        .where((Map? item) => item != null)
                        .map(
                          (Map? item) => _PassKeyItemViewCreds(item: item!),
                        )
                        .toList()
                        .cast<Widget>(),
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
