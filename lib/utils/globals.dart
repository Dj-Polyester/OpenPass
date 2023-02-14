import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:polipass/models/globals.dart';
import 'package:polipass/pages/files/files.dart';
import 'package:polipass/pages/settings.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/utils/lang.dart';

import '../main.dart';
import 'custom_page.dart';

class GlobalModel extends ChangeNotifier {
  GlobalModel() {
    for (var i = 0; i < Globals.pages.length; i++) {
      Globals.pages[i]
          .provide(CustomPageModel(title: Globals.navbarItems[i].label));
    }
  }
  double fontSize = 16, fontSizeSmall = 14;
  //
  int _selectedIndex = Globals.vaultIndex;
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

  bool listFlag = true;
  void notifyList() {
    listFlag = !listFlag;
    notifyListeners();
  }

  String searchStr = "";
  void notifySearch(String value) {
    searchStr = value;
    notifyListeners();
  }
}

class Globals {
  static const int vaultIndex = 0;
  static const String appName = "OpenPass";
  static const String fileExtension = "key";

  static EdgeInsets itemsPadding = const EdgeInsets.only(
    left: 20.0,
    right: 20.0,
    top: 2.0,
    bottom: 2.0,
  );
  static const double itemsPaddingMax = 10,
      itemsSpacing = 10,
      passKeyItemViewMinHeight = 50,
      sidePadding = 30,
      emptyIconSize = 100;

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static final List<BottomNavigationBarItem> navbarItems = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.security),
      label: Lang.tr("Vault"),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.file_copy),
      label: Lang.tr("Files"),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.settings),
      label: Lang.tr("Settings"),
    ),
  ];

  static Map routes = {
    "/": (context) => const MyHomePage(),
  };

  static List pages = [
    Vault(),
    Files(),
    Settings(),
  ];

  static bool get debugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static String globalsStr = "globals";

  static GlobalModel globalModel = GlobalModel();
  static late PersistentGlobalsModel persistentGlobalsModel;

  static Future<void> openBox() async {
    PersistentGlobalsModelAdapter persistentGlobalsModelAdapter =
        PersistentGlobalsModelAdapter();

    if (!Hive.isAdapterRegistered(persistentGlobalsModelAdapter.typeId)) {
      Hive.registerAdapter(PersistentGlobalsModelAdapter());
    }

    Box<PersistentGlobalsModel> globalsBox =
        await Hive.openBox<PersistentGlobalsModel>(globalsStr);
    persistentGlobalsModel =
        globalsBox.get(globalsStr) ?? PersistentGlobalsModel();
  }

  static Future<void> close() async {
    Hive.box<PersistentGlobalsModel>(globalsStr)
        .put(globalsStr, persistentGlobalsModel);
  }

  static final String masterKey = base64Encode(Random.secure().nextBytes(32));
}
