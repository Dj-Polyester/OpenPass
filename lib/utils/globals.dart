import 'package:flutter/material.dart';
import 'package:polipass/pages/vault.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'custom_page.dart';

class GlobalModel extends ChangeNotifier {
  GlobalModel() {
    for (var i = 0; i < Globals.pages.length; i++) {
      Globals.pages[i].provide(CustomPageModel(title: Globals.titles[i]));
    }
  }

  double fontSize = 16, fontSizeSmall = 14;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  bool checkboxFlag = true;
  void notifyCheckbox() {
    checkboxFlag = !checkboxFlag;
    notifyListeners();
  }

  bool hiveFlag = true;
  void notifyHive() {
    hiveFlag = !hiveFlag;
    notifyListeners();
  }

  String searchStr = "";
  void notifySearch(String value) {
    searchStr = value;
    notifyListeners();
  }
}

class Globals {
  static double passKeyItemViewMinHeight = 50;

  static EdgeInsets itemsPadding = const EdgeInsets.only(
    left: 20.0,
    right: 20.0,
    top: 2.0,
    bottom: 2.0,
  );
  static const double itemsPaddingMax = 10, itemsSpacing = 10;

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static const titles = [
    "Vault",
    "Settings",
  ];

  static Map routes = {
    "/": (context) => const MyHomePage(),
  };

  static List pages = [
    Vault(),
    CustomPage(
      appbar: (BuildContext context) => AppBar(
        title: Text(context.select(
          (CustomPageModel customPageModel) => customPageModel.currTitle!,
        )),
      ),
      body: (BuildContext context) => const Center(child: Text("2")),
    ),
  ];

  static bool get debugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
