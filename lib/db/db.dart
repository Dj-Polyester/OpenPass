import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as m;
import 'package:polipass/models/globals.dart';
import 'package:polipass/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:polipass/models/passkey.dart';
import 'package:crypto/crypto.dart';
import 'package:hive/src/util/extensions.dart';

class KeyStore {
  /// db operations
  static Future<void> insert(
      m.BuildContext context, PassKey passkey, String desc) async {
    KeyStore.passkeys.put(desc, passkey);
    context.read<PersistentGlobalsModel>().saved = false;
  }

  static Future<void> update(m.BuildContext context, PassKey passkey,
      String desc, String oldDesc) async {
    if (desc != oldDesc) {
      KeyStore.passkeys.delete(oldDesc);
    }
    KeyStore.passkeys.put(desc, passkey);
    context.read<PersistentGlobalsModel>().saved = false;
  }

  static Future<void> delete(
      m.BuildContext context, Iterable<dynamic> keys) async {
    KeyStore.passkeys.deleteAll(keys);
    context.read<PersistentGlobalsModel>().saved = false;
  }

  /// Uses AES. Note the IV size should be block size (128)
  static Future<String> encrypt(String plainText) async {
    String encryptionKey = (await secureStorage.read(key: encryptionKeyStr))!,
        ivKey = (await secureStorage.read(key: ivStr))!;

    Key key = Key.fromBase64(encryptionKey);
    IV iv = IV.fromBase64(ivKey);

    Encrypter encrypter =
        Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);

    return encrypted.base64;
  }

  /// Uses AES. Note the IV size should be block size (128)
  static Future<String> decrypt(String plainText) async {
    String encryptionKey = (await secureStorage.read(key: encryptionKeyStr))!,
        ivKey = (await secureStorage.read(key: ivStr))!;

    Key key = Key.fromBase64(encryptionKey);
    IV iv = IV.fromBase64(ivKey);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final decrypted = encrypter.decrypt(Encrypted.from64(plainText), iv: iv);

    return decrypted;
  }

  //passkeys
  static const String passkeysStr = "passkeys",
      encryptionKeyStr = "encryptionKey",
      slaveKeyStr = "slaveKey",
      ivStr = "iv";
  static Box<PassKey>? _passkeys;
  static Box<PassKey> get passkeys =>
      _passkeys ?? (_passkeys = Hive.box<PassKey>(passkeysStr));

  static List toJson() => passkeys.values.map((e) => e.toMap()).toList();
  static Future<void> fromJson(List entries) async => await passkeys.putAll(
        {for (Map map in entries) map["desc"]: PassKey.fromMap(map)},
      );

  static Future<void> openBox() async {
    List<int> encryptionKey =
        base64Url.decode((await secureStorage.read(key: encryptionKeyStr))!);

    Hive.registerAdapter(PassKeyAdapter());
    Hive.registerAdapter(PassKeyItemAdapter());
    await Hive.openBox<PassKey>(
      passkeysStr,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  //secureStorage

  static const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<void> storeStorageKey(List<int> masterKey) async {
    Random rnd = Random.secure();

    //https://developerb2.medium.com/store-data-securely-with-hive-flutter-cbad35981880
    var containsEncryptionKey =
        await secureStorage.containsKey(key: encryptionKeyStr);
    if (!containsEncryptionKey) {
      List<int> slaveKey = Hive.generateSecureKey();
      List<int> encryptionKey = sha256.convert(masterKey + slaveKey).bytes;
      //16 bytes = 128 bits, block size of AES
      List<int> iv = rnd.nextBytes(16);

      String slaveKeyEncoded = base64UrlEncode(slaveKey),
          encryptionKeyEncoded = base64UrlEncode(slaveKey),
          ivEncoded = base64UrlEncode(iv);

      await secureStorage.write(key: slaveKeyStr, value: slaveKeyEncoded);
      await secureStorage.write(
          key: encryptionKeyStr, value: encryptionKeyEncoded);
      await secureStorage.write(key: ivStr, value: ivEncoded);
    }
  }

  static Future<void> deleteStorageKeys() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll();
  }
}
