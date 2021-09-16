import 'package:flutter/material.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/pages/vault/vault_list.dart';
import 'package:provider/provider.dart';

enum CustomListBuilderType {
  valueListenable,
  future,
  stream,
}

class CustomList extends StatelessWidget {
  CustomList({
    Key? key,
    required this.object,
    Function(BuildContext, dynamic)? prebuild,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(Globals.itemsPaddingMax),
    required this.builderType,
  })  : _prebuild = prebuild ?? ((context, obj) => obj),
        super(key: key);

  final EdgeInsets padding;
  final dynamic object;
  final Function(BuildContext, dynamic) _prebuild;
  final Function(BuildContext, List, int) itemBuilder;
  final CustomListBuilderType builderType;

  @override
  Widget build(BuildContext context) => builder(context);

  builder(BuildContext context) {
    switch (builderType) {
      case CustomListBuilderType.valueListenable:
        return valueListenableBuilder(context);
      case CustomListBuilderType.future:
        return;
      case CustomListBuilderType.stream:
        return;
      default:
    }
  }

  ValueListenableBuilder valueListenableBuilder(BuildContext context) =>
      ValueListenableBuilder(
        valueListenable: object.listenable()!,
        builder: (context, obj, _) {
          List list = _prebuild(context, obj);
          return ListView.builder(
            padding: padding,
            //
            itemCount: list.length,
            itemBuilder: (BuildContext context, int i) =>
                itemBuilder(context, list, i),
          );
        },
      );
  // FutureBuilder futureBuilder(BuildContext context) => FutureBuilder(builder: builder);

  // StreamBuilder streamBuilder(BuildContext context) => FutureBuilder(builder: builder);
}
