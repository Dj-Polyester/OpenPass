import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
part 'passkey.g.dart';

class PassKeyModel extends ChangeNotifier {
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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String _formKeySwitch;
  String get formKeySwitch => _formKeySwitch;
  set formKeySwitch(String value) {
    _formKeySwitch = value;
    notifyListeners();
  }
}

class PassKeyItem {
  PassKeyItem({
    required this.name,
    required this.value,
    this.isSecret = false,
  });
  String name, value;
  bool isSecret;
}

@HiveType(typeId: 0)
class PassKey extends HiveObject {
  PassKey({
    required this.desc,
    this.username,
    this.email,
    required this.password,
  });
  @HiveField(0)
  String desc;
  @HiveField(1)
  String? username;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String password;

  List<PassKeyItem?>? _items;
  List<PassKeyItem?> get items => _items ??= [
        PassKeyItem(
          name: "desc",
          value: desc,
        ),
        (username == null)
            ? null
            : PassKeyItem(
                name: "username",
                value: username!,
              ),
        (email == null)
            ? null
            : PassKeyItem(
                name: "email",
                value: email!,
              ),
        PassKeyItem(
          name: "password",
          value: password,
          isSecret: true,
        ),
      ];
}
