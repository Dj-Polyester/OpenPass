import 'package:flutter/material.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/utils/lang.dart';
import 'package:string_validator/string_validator.dart';

class Validator {
  final Map<String, String> _chars = const {
    "az": "abcdefghijklmnopqrstuvwxyz",
    "AZ": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "09": "0123456789",
    "special": " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~",
    // "ambiguous": "l1O0",
  };

  Validator({
    this.allowedChars = const {},
    this.numChars = const {},
    this.length = 0,
    required this.text,
  }) : messages = [];

  Validator.fromMap({
    required Map<String, dynamic> map,
    required this.text,
  })  : allowedChars = map["allowedChars"],
        numChars = map["numChars"],
        length = map["length"],
        messages = [];

  //settings
  final Map<String, bool> allowedChars;
  final Map<String, int> numChars;
  final int length;
  //password text
  final String? text;
  //returned messages
  List<String> messages;
  Map messageEntries = {
    "containsMessage": Lang.tr("The password entered contains"),
    "az": Lang.tr("* small letters"),
    "AZ": Lang.tr("* capitalized letters"),
    "09": Lang.tr("* numbers"),
    "special": Lang.tr("* special characters"),
    "ambiguous": (String char) => Lang.tr("* the character %s", [char]),
    "invalidMessage": Lang.tr("Therefore is not a valid password"),
    "validateExistingDesc":
        Lang.tr("* An entry with the description already exists"),
    "validateEmpty": Lang.tr("* Please enter some text"),
    "validateEmail": Lang.tr("* The email entered is not valid"),
    "validateASCII":
        Lang.tr("* The text entered contains non-ASCII characters"),
    "invalidSum":
        Lang.tr("* Sum of minimum allowed characters exceeds the length"),
  };

  bool validateSumSettings() {
    debugPrint("numChars: $numChars");
    int sum = numChars.values.fold<int>(0, (prev, curr) => prev + curr);
    if (sum > length) {
      messages.add(messageEntries["invalidSum"]);
      return false;
    }
    return true;
  }

  bool validateAllSettings() {
    bool result = true;
    for (int passwdrune in text!.runes) {
      for (String key in _chars.keys) {
        for (int charune in _chars[key]!.runes) {
          if (passwdrune == charune) {
            //found char in list of [key]
            if (!allowedChars[key]! && key != "ambiguous") {
              // not allowed: REJECT
              if (!messages.contains(messageEntries["containsMessage"]))
                // ignore: curly_braces_in_flow_control_structures
                messages.add(messageEntries["containsMessage"]);
              if (!messages.contains(messageEntries[key]))
                // ignore: curly_braces_in_flow_control_structures
                messages.add(messageEntries[key]);
              result = false;
            }
          }
        }
      }
      if (!allowedChars["ambiguous"]!) {
        String char = String.fromCharCode(passwdrune);
        switch (char) {
          case "l":
          case "1":
          case "O":
          case "0":
            if (!messages.contains(messageEntries["containsMessage"]))
              // ignore: curly_braces_in_flow_control_structures
              messages.add(messageEntries["containsMessage"]);

            String ambiguousTxt = messageEntries["ambiguous"](char);
            if (!messages.contains(ambiguousTxt))
              // ignore: curly_braces_in_flow_control_structures
              messages.add(ambiguousTxt);
            result = false;
            break;
        }
      }
    }
    if (!result) {
      if (!messages.contains(messageEntries["invalidMessage"]))
        // ignore: curly_braces_in_flow_control_structures
        messages.add(messageEntries["invalidMessage"]);
    }
    return result;
  }

  bool validateExistingDesc() {
    if (KeyStore.passkeys.get(text!) != null) {
      messages.add(messageEntries["validateExistingDesc"]);
      return false;
    }
    return true;
  }

  bool validateInput() {
    bool result = true;
    result = validateASCII() && result;
    result = validateEmpty() && result;
    return result;
  }

  bool validateDesc() {
    bool result = true;
    result = validateInput() && result;
    result = validateExistingDesc() && result;
    return result;
  }

  bool validateEmailAll() {
    bool result = true;
    result = validateASCII() && result;
    result = validateEmail() && result;
    return result;
  }

  bool validateEmail() {
    if (!isEmail(text!)) {
      messages.add(messageEntries["validateEmail"]);

      return false;
    }
    return true;
  }

  bool validatePasswd() {
    bool result = true;
    result = validateInput() && result;
    result = validateSumSettings() && result;
    result = validateAllSettings() && result;
    return result;
  }

  bool validateUsername() {
    bool result = true;
    result = validateASCII() && result;
    return result;
  }

  bool validatePassword() => validateInput();

  bool validateASCII() {
    if (text!.isNotEmpty && !isAscii(text!)) {
      messages.add(messageEntries["validateASCII"]);

      return false;
    }
    return true;
  }

  bool validateEmpty() {
    if (text == null || text!.isEmpty) {
      messages.add(messageEntries["validateEmpty"]);

      return false;
    }
    return true;
  }

  String? validateAll({
    List<bool>? conditions,
    List<bool Function(Validator)> validators = const [],
    String? value,
  }) {
    conditions ??= validators.map((_) => true).toList();

    for (var i = 0; i < validators.length; i++) {
      if (conditions[i] && !validators[i](this)) {
        return format();
      }
    }
    return null;
  }

  String format() => messages.join("\n");
  // String format() => messages
  //               .map((String str) => "* " + str)
  //               .join("\n");
}
