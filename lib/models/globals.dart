import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
part 'globals.g.dart';

@HiveType(typeId: 2)
class PersistentGlobalsModel extends HiveObject with ChangeNotifier {
  PersistentGlobalsModel();

  //Persistent
  @HiveField(0)
  bool _saved = true;
  bool get saved => _saved;
  set saved(bool newval) {
    _saved = newval;
    notifyListeners();
  }

  @HiveField(1)
  bool _requirePasswd = true;
  bool get requirePasswd => _requirePasswd;
  set requirePasswd(bool newval) {
    _requirePasswd = newval;
    notifyListeners();
  }

  @HiveField(2)
  String _themeData = "Light";
  String get themeData => _themeData;
  set themeData(String newval) {
    _themeData = newval;
    notifyListeners();
  }

  @HiveField(3)
  String _darkThemeData = "Dark";
  String get darkThemeData => _darkThemeData;
  set darkThemeData(String newval) {
    _darkThemeData = newval;
    notifyListeners();
  }
}
