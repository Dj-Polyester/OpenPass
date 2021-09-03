import 'package:hive/hive.dart';
import 'package:polipass/models/passkey.dart';

class KeyStore {
  Future<void> register() async {}

  static late Box<PassKey> passkeys = Hive.box<PassKey>("passkeys");
}
