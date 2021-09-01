import 'dart:math';

class Generator {
  final Map<String, String> _chars = const {
    "az": "abcdefghijklmnopqrstuvwxyz",
    "AZ": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "09": "0123456789",
    "special": " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~",
    "ambiguous": "l1O0",
  };

  Generator({
    required this.allowedChars,
    required this.numChars,
    required this.length,
  });

  //settings
  final Map<String, bool> allowedChars;
  final Map<String, int> numChars;
  final int length;
  Random rnd = Random.secure();

  Map<String, int> generateNums() {
    Map<String, int> numCharsTmp = {};
    int sum = numChars.values.fold<int>(0, (prev, curr) => prev + curr),
        numCharsLength = numChars.length,
        remaining = length,
        remainingMin = sum;

    for (String key in numChars.keys) {
      if (allowedChars[key]!) {
        late int newval;
        //last key
        if (--numCharsLength == 0) {
          newval = remaining;
        } else {
          int currMin = numChars[key]!;
          remainingMin -= currMin;

          newval =
              rnd.nextInt((remaining - remainingMin) - currMin + 1) + currMin;

          remaining -= newval;
        }
        numCharsTmp[key] = newval;
      }
    }
    return numCharsTmp;
  }

  String generate() {
    Map<String, int> numCharsTmp = generateNums();
    String passwordText = "";
    for (String key in numCharsTmp.keys) {
      String alphabet = _chars[key]!;

      int newval = numCharsTmp[key]!;

      while (newval != 0) {
        passwordText += alphabet[rnd.nextInt(alphabet.length)];
        --newval;
      }
    }
    return shuffle(passwordText);
  }

  String shuffle(String passwordText) {
    List passwdCharsList = passwordText.split("");
    passwdCharsList.shuffle(rnd);
    return passwdCharsList.join("");
  }
}
