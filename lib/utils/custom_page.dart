import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'globals.dart';

class CustomPageModel extends ChangeNotifier {
  CustomPageModel({
    this.title,
  }) {
    _currTitle = title;
  }

  void provide(Locator read) {
    globalModel = read<GlobalModel>();
  }

  late GlobalModel globalModel;
  String? title, _currTitle;

  String? get currTitle => _currTitle;
  set currTitle(String? value) {
    _currTitle = value;
    notifyListeners();
  }

  Map<String, bool> selectedItems = {};

  void setSelectedItems(bool value) {
    for (var key in selectedItems.keys) {
      selectedItems[key] = value;
    }
    notifyListeners();
  }

  void updateSelectedItems(String key, bool value) {
    selectedItems[key] = value;
    notifyListeners();
  }

  bool checkboxValue = false;
  void setCheckbox(bool value) {
    setSelectedItems(value);
    checkboxValue = value;
    if (value) {
      selectedNum = selectedItems.length;
    } else {
      selectedNum = 0;
    }
    //print(contactModel.currTitle);
    //print(phones);
    //print(selectedItems);
    currTitle = (itemSelectVisible) ? "Selected $selectedNum" : title!;
    notifyListeners();
  }

  bool itemSelectVisible = false;
  bool toggleVisibility() {
    itemSelectVisible = !itemSelectVisible;

    setCheckbox(false);

    notifyListeners();
    return itemSelectVisible;
  }

  void turnOffVisibility() {
    itemSelectVisible = false;
    notifyListeners();
  }

  int selectedNum = 0;
  void incSelectedNum() {
    if (++selectedNum == selectedItems.length) checkboxValue = true;
    notifyListeners();
  }

  void decSelectedNum() {
    if (selectedNum-- == selectedItems.length) checkboxValue = false;
    notifyListeners();
  }
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
