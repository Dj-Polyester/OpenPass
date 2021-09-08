import 'package:hive/hive.dart';
import 'package:polipass/models/passkey.dart';

class KeyStore {
  Future<void> register() async {}

  static Box<PassKey> get passkeys => Hive.box<PassKey>("passkeys");

  static List toJson() => passkeys.values.map((e) => e.toMap()).toList();
  static Future<void> fromJson(List entries) async => await passkeys.putAll(
        {for (Map map in entries) map["desc"]: PassKey.fromMap(map)},
      );
}
