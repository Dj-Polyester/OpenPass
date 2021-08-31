import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/pages/vault.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_slider_passwd.dart';
import 'package:polipass/widgets/validator.dart';

class PasswdScreen extends StatelessWidget {
  PasswdScreen({Key? key}) : super(key: key);

  final Map<String, GlobalKey<FormState>> formKeys = {
    "submit": GlobalKey<FormState>(),
    "generate": GlobalKey<FormState>(),
  };

  late final TextEditingController dialogController = TextEditingController();

  late final Map<String, dynamic> dialogOptions = {
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
    "length": CustomTextSliderPasswdWithProvider(
      labelText: "Password",
      hintText: "Enter password",
      text: "Length",
      value: 12,
      validator: (String? value) {
        // TODO compare value and settings, reject if inconsistent

        Validator validator = getSettings(value!);

        if (!validator.validatePasswd()) {
          return validator.messages.map((String str) => "* " + str).join("\n");
        }
        return null;
      },
    ),
  };

  Validator getSettings(String text) {
    Map<String, int> settings = {};
    Map<String, bool> settingsAllowed = {};

    for (String key in dialogOptions.keys) {
      dynamic item = dialogOptions[key];

      if (item is CustomTextCheckboxWithProvider ||
          item is CustomTextCheckboxSliderWithProvider) {
        settingsAllowed[key] = item.checkboxModel.value;
      }
      if (item is CustomTextSliderPasswdWithProvider ||
          item is CustomTextCheckboxSliderWithProvider) {
        settings[key] = item.sliderModel.value.toInt();
      }
    }

    int length = dialogOptions["length"]!.sliderModel.value.toInt();
    settings.remove("length");

    print("length: $length");
    print("settings: $settings");
    print("settingsAllowed: $settingsAllowed");

    return Validator(
        allowedChars: settingsAllowed,
        numChars: settings,
        length: length,
        text: text);
  }

  //dialog widgets

  late final Map<String, dynamic> dialogButtons = {
    "submit": (BuildContext context) => TextButton(
          onPressed: () {
            context.read<VaultDialogModel>().setCurrForm("submit");
            // Validate returns true if the form is valid, or false otherwise.
            if (formKeys["submit"]!.currentState!.validate()) {
              // TODO submit the info to the hive database and quit.

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Submitting")),
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
    "generate": (BuildContext context) => TextButton(
          onPressed: () {
            // context.read<VaultDialogModel>().setCurrForm("generate");
            // Validate returns true if the form is valid, or false otherwise.
            if (formKeys["submit"]!.currentState!.validate()) {
              // TODO generate the text.

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
                key: formKeys[context.select(
                    (VaultDialogModel vaultDialogModel) =>
                        vaultDialogModel.currForm)],
                child: Column(
                  children: <Widget>[
                    dialogOptions["length"],
                    AnimatedSize(
                      alignment: Alignment.topCenter,
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 200),
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
