import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:polipass/models/passkey.dart';
import 'package:crypto/crypto.dart';

class KeyStore {
  //passkeys
  static const String passkeysStr = "passkeys",
      encryptionKeyStr = "encryptionKey",
      slaveKeyStr = "slaveKey";
  static Box<PassKey>? _passkeys;
  static Box<PassKey> get passkeys =>
      _passkeys ?? (_passkeys = Hive.box<PassKey>(passkeysStr));

  static List toJson() => passkeys.values.map((e) => e.toMap()).toList();
  static Future<void> fromJson(List entries) async => await passkeys.putAll(
        {for (Map map in entries) map["desc"]: PassKey.fromMap(map)},
      );

  static Future<void> openBox() async {
    var encryptionKey =
        base64Url.decode((await _secureStorage.read(key: encryptionKeyStr))!);

    if (Hive.isBoxOpen(passkeysStr)) {
      Hive.close();
    }

    Hive.registerAdapter(PassKeyAdapter());
    Hive.registerAdapter(PassKeyItemAdapter());
    await Hive.openBox<PassKey>(
      passkeysStr,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  //secureStorage

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> storeStorageKey(List<int> masterKey) async {
    //https://developerb2.medium.com/store-data-securely-with-hive-flutter-cbad35981880
    var containsEncryptionKey =
        await _secureStorage.containsKey(key: encryptionKeyStr);
    if (!containsEncryptionKey) {
      List<int> slaveKey = Hive.generateSecureKey();
      List<int> encryptionKey = sha256.convert(masterKey + slaveKey).bytes;

      await _secureStorage.write(
          key: slaveKeyStr, value: base64UrlEncode(slaveKey));
      await _secureStorage.write(
          key: encryptionKeyStr, value: base64UrlEncode(encryptionKey));
    }
  }

  static Future<void> deleteStorageKeys() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
  }
}
