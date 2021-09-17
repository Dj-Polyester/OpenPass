import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'passkey.g.dart';

class PassKeyItemModel extends ChangeNotifier {
  bool obscureSecret = true;
  void toggleVisibility() {
    obscureSecret = !obscureSecret;
    notifyListeners();
  }

  void showSecret() {
    obscureSecret = false;
    notifyListeners();
  }

  void hideSecret() {
    obscureSecret = true;
    notifyListeners();
  }
}

class PassKeyModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String _formKeySwitch;
  String get formKeySwitch => _formKeySwitch;
  set formKeySwitch(String value) {
    _formKeySwitch = value;
    notifyListeners();
  }
}

@HiveType(typeId: 1)
class PassKeyItem extends HiveObject {
  PassKeyItem({
    required this.name,
    required this.value,
    this.isSecret = false,
  });
  PassKeyItem.fromMap(Map map)
      : name = map["name"],
        value = map["value"],
        isSecret = map["isSecret"];
  Map<String, dynamic> toMap() => {
        "name": name,
        "value": value,
        "isSecret": isSecret,
      };

  @HiveField(0)
  String name;
  @HiveField(1)
  String value;
  @HiveField(2)
  bool isSecret;
}

@HiveType(typeId: 0)
class PassKey extends HiveObject {
  PassKey({
    this.desc = "",
    this.username = "",
    this.email = "",
    this.password = "",
    this.other = const {},
  });

  PassKey.fromMap(Map map)
      : desc = map["desc"],
        username = map["username"],
        email = map["email"],
        password = map["password"],
        other = map["other"]
            .map((key, value) => MapEntry(key, PassKeyItem.fromMap(value)))
            .cast<String, PassKeyItem>();

  Map<String, dynamic> toMap() {
    return {
      "desc": desc,
      "username": username,
      "email": email,
      "password": password,
      "other": other.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  @HiveField(0)
  String desc;
  @HiveField(1)
  String username;
  @HiveField(2)
  String email;
  @HiveField(3)
  String password;
  @HiveField(4)
  Map<String, PassKeyItem> other;

  List<PassKeyItem> get items =>
      [
        PassKeyItem(
          name: "Description",
          value: desc,
        ),
        PassKeyItem(
          name: "Username",
          value: username,
        ),
        PassKeyItem(
          name: "Email",
          value: email,
        ),
        PassKeyItem(
          name: "Password",
          value: password,
          isSecret: true,
        ),
      ] +
      other.entries.map((e) => e.value).toList();
}
