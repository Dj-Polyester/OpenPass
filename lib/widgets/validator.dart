class Validator {
  final Map<String, String> _chars = const {
    "az": "abcdefghijklmnopqrstuvwxyz",
    "AZ": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "09": "0123456789",
    "special": " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~",
    "ambiguous": "l1O0",
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

  bool validateSumSettings() {
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
            if (!allowedChars[key]!) {
              // not allowed: REJECT
              String message = "$key is invalid";
              if (!messages.contains(message)) {
                messages.add(message);
              }
              result = false;
            }
          }
        }
      }
    }
    return result;
  }

  bool validatePasswd() {
    bool result = true;
    result = validateInput() && result;
    result = validateSumSettings() && result;
    result = validateAllSettings() && result;
    return result;
  }

  bool validateInput() {
    if (text == null || text!.isEmpty) {
      messages.add("Please enter some text");
      return false;
    }
    return true;
  }
}
