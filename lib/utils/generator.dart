import 'dart:math';

class Generator {
  final Map<String, String> _chars = const {
    "az": "abcdefghijklmnopqrstuvwxyz",
    "AZ": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "09": "0123456789",
    "special": " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~",
  };
  final Map<String, String> _nonambigiuousChars = const {
    "az": "abcdefghijkmnopqrstuvwxyz",
    "AZ": "ABCDEFGHIJKLMNPQRSTUVWXYZ",
    "09": "23456789",
    "special": " !\"#\$%&'()*+,-./:;<=>?@[\\]^_`{|}~",
  };

  Generator({
    required this.allowedChars,
    required this.numChars,
    required this.length,
  });

  Generator.fromMap(Map<String, dynamic> map)
      : allowedChars = map["allowedChars"],
        numChars = map["numChars"],
        length = map["length"];

  //settings
  final Map<String, bool> allowedChars;
  final Map<String, int> numChars;
  final int length;
  Random rnd = Random.secure();

  Map<String, int> generateNums() {
    Map<String, int> numCharsTmp = {};
    int sum = numChars.values.fold<int>(0, (prev, curr) => prev + curr),
        allowedCharsLength = allowedChars.entries.where((e) => e.value).length,
        //numCharsLength = numChars.length,
        remaining = length,
        remainingMin = sum;
    //print("start:");
    //print("numChars: $numChars");
    //print("numCharsLength: $numCharsLength");
    //print("allowedChars: $allowedChars");
    //print("allowedCharsLength: $allowedCharsLength");
    //print("remaining: $remaining");
    //print("remainingMin: $remainingMin");

    if (allowedChars["ambiguous"]!) {
      --allowedCharsLength;
    }

    for (String key in numChars.keys) {
      if (allowedChars[key]! && key != "ambiguous") {
        //print("key: $key");
        late int newval;
        //last key
        if (--allowedCharsLength == 0) {
          newval = remaining;
        } else {
          int currMin = numChars[key]!;
          remainingMin -= currMin;
          //print("currMin: $currMin");
          //print("remainingMin: $remainingMin");

          newval =
              rnd.nextInt((remaining - remainingMin) - currMin + 1) + currMin;
          //print("newval: $newval");
          remaining -= newval;
          //print("remaining: $remaining");
        }
        numCharsTmp[key] = newval;
      }
    }
    //print(numCharsTmp);
    return numCharsTmp;
  }

  String generate() {
    Map<String, int> numCharsTmp = generateNums();
    String passwordText = "";
    for (String key in numCharsTmp.keys) {
      String alphabet = (allowedChars["ambiguous"]!)
          ? _chars[key]!
          : _nonambigiuousChars[key]!;

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
