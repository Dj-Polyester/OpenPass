import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_animated_size.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/pages/vault.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_slider_passwd.dart';
import 'package:polipass/utils/validator.dart';

class PasswdScreen extends StatelessWidget {
  PasswdScreen({Key? key, this.globalPasskey}) : super(key: key);

  PassKey? globalPasskey;

  late String formKeySwitch;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? validator({
    List<bool> conditions = const [],
    List<String Function(String? value)> functions = const [],
    String? value,
  }) {
    for (var i = 0; i < conditions.length; i++) {
      if (conditions[i]) {
        return functions[i](value);
      }
    }
    return null;
  }

  late final Map<String, dynamic> dialogOptions = {
    "desc": CustomTextWithProvider(
      labelText: "Description",
      hintText: "Enter description",
      validator: (String? value) {
        //compare value and settings, reject if inconsistent
        if (formKeySwitch == "submit") {
          Validator validator = getValidator(value!);

          if (!validator.validateDesc()) {
            return validator.format();
          }
        }
        return null;
      },
      inputText: (globalPasskey == null) ? null : globalPasskey!.desc,
    ),
    "username": CustomTextWithProvider(
      labelText: "Username (optional)",
      hintText: "Enter username",
      inputText: (globalPasskey == null) ? null : globalPasskey!.username,
    ),
    "email": CustomTextWithProvider(
      labelText: "Email (optional)",
      hintText: "Enter email",
      validator: (String? value) {
        //compare value and settings, reject if inconsistent
        if (formKeySwitch == "submit" && value!.isNotEmpty) {
          Validator validator = getValidator(value);

          if (!validator.validateEmail()) {
            return validator.format();
          }
        }
        return null;
      },
      inputText: (globalPasskey == null) ? null : globalPasskey!.email,
    ),
    "length": CustomTextSecretWithProvider(
      labelText: "Password",
      hintText: "Enter password",
      text: "Length",
      value: 12,
      //VALIDATE
      validator: (String? value) {
        //TODO compare value and settings, reject if inconsistent

        Validator validator = getValidator(value!);

        switch (formKeySwitch) {
          case "submit":
            if (!validator.validatePasswd()) {
              return validator.format();
            }
            return null;
          case "generate":
            if (!validator.validateSumSettings()) {
              return validator.format();
            }
            return null;
          default:
        }
        return null;
      },
      inputText: (globalPasskey == null) ? null : globalPasskey!.password,
    ),
    "az": CustomTextCheckboxSliderWithProvider(
      text1: "Allow lowercase letters",
      text2: " (a-z)",
      text3: "Minimum",
    ),
    "AZ": CustomTextCheckboxSliderWithProvider(
      text1: "Allow uppercase letters",
      text2: " (A-Z)",
      text3: "Minimum",
    ),
    "09": CustomTextCheckboxSliderWithProvider(
      text1: "Allow numeric characters",
      text2: " (0-9)",
      text3: "Minimum",
    ),
    "special": CustomTextCheckboxSliderWithProvider(
      text1: "Allow special characters",
      text2: " (!,<,>,|,',£,^,#,+,\$,%,&,/,=,?,*,\\,-,_)",
      text3: "Minimum",
    ),
    "ambiguous": CustomTextCheckboxWithProvider(
      text1: "Allow ambiguous letters",
      text2: " (l,1,O,0)",
    ),
  };

  Map<String, dynamic> getSettings({String? text}) {
    Map<String, int> numChars = {};
    Map<String, bool> allowedChars = {};

    for (String key in dialogOptions.keys) {
      dynamic item = dialogOptions[key];

      if (item is CustomTextCheckboxWithProvider ||
          item is CustomTextCheckboxSliderWithProvider) {
        allowedChars[key] = item.checkboxModel.value;
      }
      if (item is CustomTextSecretWithProvider ||
          item is CustomTextCheckboxSliderWithProvider) {
        numChars[key] = item.sliderModel.value.toInt();
      }
    }

    int length = dialogOptions["length"]!.sliderModel.value.toInt();
    numChars.remove("length");

    debugPrint("text: $text");
    debugPrint("length: $length");
    debugPrint("numChars: $numChars");
    debugPrint("allowedChars: $allowedChars");

    return {
      "text": text,
      "length": length,
      "numChars": numChars,
      "allowedChars": allowedChars,
    };
  }

  Validator getValidator(String text) {
    Map<String, dynamic> settings = getSettings(text: text);

    return Validator(
      allowedChars: settings["allowedChars"],
      numChars: settings["numChars"],
      length: settings["length"],
      text: settings["text"],
    );
  }

  Generator getGenerator() {
    Map<String, dynamic> settings = getSettings();

    return Generator(
      allowedChars: settings["allowedChars"],
      numChars: settings["numChars"],
      length: settings["length"],
    );
  }

  //dialog widgets

  late final Map<String, dynamic> dialogButtons = {
    //SUBMIT
    "submit": (BuildContext context) => TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            // dialogOptions["length"]!.textPasswdModel.focusNode.unfocus();
            formKeySwitch = "submit";

            // Validate returns true if the form is valid, or false otherwise.
            if (formKey.currentState!.validate()) {
              // TODO submit the info to the hive database.

              String desc = dialogOptions["desc"].textModel.controller.text,
                  username =
                      dialogOptions["username"].textModel.controller.text,
                  email = dialogOptions["email"].textModel.controller.text,
                  password =
                      dialogOptions["length"].textPasswdModel.controller.text;

              PassKey passkey = PassKey(
                desc: desc,
                username: (username == "") ? null : username,
                email: (email == "") ? null : email,
                password: password,
              );

              print("passkey: $passkey");

              if (globalPasskey == null) {
                //INSERT
                if (KeyStore.passkeys.get(passkey.desc) == null) {
                  // KeyStore.passkeys.add(passkey);
                  KeyStore.passkeys.put(passkey.desc, passkey);
                  // context.read<GlobalModel>().notifyHive();
                }
              } else {
                //UPDATE
                if (globalPasskey!.desc != passkey.desc) {
                  KeyStore.passkeys.delete(globalPasskey!.desc);
                }
                KeyStore.passkeys.put(passkey.desc, passkey);
              }

              // quit
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text("Added the key with description ${passkey.desc}")),
              );
            }
          },
          child: const Text("Submit"),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor:
                MaterialStateProperty.all<Color>(const Color(0x33FFFFFF)),
          ),
        ),
    //GENERATE
    "generate": (BuildContext context) => TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            // dialogOptions["length"]!.textPasswdModel.focusNode.unfocus();
            formKeySwitch = "generate";

            // Validate returns true if the form is valid, or false otherwise.
            if (formKey.currentState!.validate()) {
              Generator generator = getGenerator();

              dialogOptions["length"]!.textPasswdModel.controller.text =
                  generator.generate();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Generating")),
              );
            }
          },
          child: const Text("Generate"),
        ),
    "settings": (BuildContext context) => TextButton(
          onPressed: () {
            context.read<VaultDialogModel>().toggleVisibility();
          },
          child: const Text("Settings"),
        ),
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VaultDialogModel(),
      builder: (context, _) => AlertDialog(
        content: SingleChildScrollView(
          child: Wrap(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    dialogOptions["desc"],
                    dialogOptions["username"],
                    dialogOptions["email"],
                    dialogOptions["length"],
                    CustomAnimatedSize(
                      child: Selector<VaultDialogModel, bool>(
                        selector: (_, vaultDialogModel) =>
                            vaultDialogModel.isSettingsVisible,
                        builder: (_, isSettingsVisible, __) => Offstage(
                          offstage: !isSettingsVisible,
                          child: Column(
                            children: [
                              dialogOptions["az"],
                              dialogOptions["AZ"],
                              dialogOptions["09"],
                              dialogOptions["special"],
                              dialogOptions["ambiguous"],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: dialogButtons["submit"]!(context),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: dialogButtons["generate"]!(context),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: dialogButtons["settings"]!(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
