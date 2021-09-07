import 'package:flutter/material.dart';
import 'package:polipass/widgets/api/custom_list.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'globals.dart';

class CustomPageModel extends ChangeNotifier {
  CustomPageModel({this.title}) : currTitle = title;

  void provide(Locator read) {
    globalModel = read<GlobalModel>();
  }

  late GlobalModel globalModel;
  String? title, currTitle;
  void setCurrTitle(String? newTitle) {
    currTitle = newTitle;
    notifyListeners();
  }
}

class CustomPage {
  CustomPage({
    this.appbar,
    this.body,
    this.fab,
    this.screens,
    this.hasList = false,
  });

  bool hasList;

  void provide(CustomPageModel customPageModel) {
    List<SingleChildWidget> providers = [
      ChangeNotifierProvider.value(value: customPageModel),
    ];

    if (hasList) {
      //use value with MultiProvider
      CustomListModel customListModel = CustomListModel();
      providers.add(ChangeNotifierProvider.value(value: customListModel));
      // providers.add(ChangeNotifierProvider(create: (_) => CustomListModel()));
    }

    if (appbar != null) {
      Widget Function(BuildContext) tmp = appbar!;
      appbar = PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: refine(providers, tmp),
      );
    }
    if (body != null) {
      Widget Function(BuildContext) tmp = body!;
      body = refine(providers, tmp);
    }
    if (fab != null) {
      Widget Function(BuildContext) tmp = fab!;
      fab = refine(providers, tmp);
    }
    if (screens != null) {
      Map tmp = screens!.map(
        (key, value) => MapEntry(
          key,
          (BuildContext context) => refine(providers, value),
        ),
      );
      Globals.routes = {...Globals.routes, ...tmp};
    }
  }

  MultiProvider refine(
    List<SingleChildWidget> providers,
    Widget Function(BuildContext) child,
  ) =>
      MultiProvider(
        providers: providers,
        builder: (context, _) => child(context),
      );

  dynamic appbar, body, fab;
  Map? screens;
}
