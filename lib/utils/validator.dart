import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';

class Validator {
  final Map<String, String> _chars = const {
    "az": "abcdefghijklmnopqrstuvwxyz",
    "AZ": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "09": "0123456789",
    "special": " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~",
    // "ambiguous": "l1O0",
  };

  Validator({
    required this.allowedChars,
    required this.numChars,
    required this.length,
    this.text,
  }) : messages = [];

  //settings
  final Map<String, bool> allowedChars;
  final Map<String, int> numChars;
  final int length;
  //password text
  final String? text;
  //returned messages
  List<String> messages;
  Map messageEntries = {
    "containsMessage": "The password entered contains",
    "az": "* small letters",
    "AZ": "* capitalized letters",
    "09": "* numbers",
    "special": "* special characters",
    "ambiguous": (char) => "* the character $char",
    "invalidMessage": "Therefore is not a valid password",
    "validateExistingDesc": "* An entry with the description already exists",
    "validateInput": "* Please enter some text",
    "validateEmail": "* The email entered is not valid",
  };

  bool validateSumSettings() {
    debugPrint("numChars: $numChars");
    int sum = numChars.values.fold<int>(0, (prev, curr) => prev + curr);
    if (sum > length) {
      messages.add("sum is invalid");
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
            if (!messages.contains(messageEntries["ambiguous"](char)))
              // ignore: curly_braces_in_flow_control_structures
              messages.add(messageEntries["ambiguous"](char));
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
    if (text == null || text!.isEmpty) {
      messages.add(messageEntries["validateInput"]);

      return false;
    }
    return true;
  }

  bool validateDesc() {
    bool result = true;
    result = validateInput() && result;
    result = validateExistingDesc() && result;
    return result;
  }

  bool validateEmail() {
    if (!EmailValidator.validate(text!)) {
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

  String format() => messages.join("\n");
  // String format() => messages
  //               .map((String str) => "* " + str)
  //               .join("\n");
}
