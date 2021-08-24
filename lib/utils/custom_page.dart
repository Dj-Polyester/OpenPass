import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'globals.dart';

class CustomPageModel extends ChangeNotifier {
  CustomPageModel({
    this.title,
  }) {
    currTitle = title;
  }

  void provide(Locator read) {
    globalModel = read<GlobalModel>();
  }

  late GlobalModel globalModel;
  String? title, currTitle;
}

class CustomPage {
  CustomPage({this.appbar, this.body, this.fab, this.screens});

  void provide(CustomPageModel customPageModel) {
    if (appbar != null) {
      Widget Function(BuildContext) tmp = appbar!;
      appbar = PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: refine(customPageModel, tmp),
      );
    }
    if (body != null) {
      Widget Function(BuildContext) tmp = body!;
      body = refine(customPageModel, tmp);
    }
    if (fab != null) {
      Widget Function(BuildContext) tmp = fab!;
      fab = refine(customPageModel, tmp);
    }
    if (screens != null) {
      Map tmp = screens!.map(
        (key, value) => MapEntry(
          key,
          (BuildContext context) => refine(customPageModel, value),
        ),
      );
      Globals.routes = {...Globals.routes, ...tmp};
    }
  }

  ChangeNotifierProvider<CustomPageModel> refine(
    CustomPageModel customPageModel,
    Widget Function(BuildContext) child,
  ) =>
      ChangeNotifierProvider<CustomPageModel>.value(
        value: customPageModel,
        builder: (context, _) => child(context),
      );

  dynamic appbar, body, fab;
  Map? screens;
}
