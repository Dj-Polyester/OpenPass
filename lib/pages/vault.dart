import 'package:flutter/material.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_slider_passwd.dart';
import 'package:polipass/widgets/validator.dart';
import 'package:provider/provider.dart';

class VaultDialogModel extends ChangeNotifier {
  VaultDialogModel({this.settingsHeightMax = 400})
      : settingsHeight = settingsHeightMax;
  final double settingsHeightMax;
  double settingsHeight;

  bool isSettingsVisible = false;
  void toggleVisibility() {
    isSettingsVisible = !isSettingsVisible;
    settingsHeight = (settingsHeight == 0) ? settingsHeightMax : 0;
    notifyListeners();
  }

  String currForm = "submit";
  void setCurrForm(String val) {
    currForm = val;
    notifyListeners();
  }
}

class Vault extends CustomPage {
  Vault()
      : super(
          appbar: (BuildContext context) => AppBar(
            title: Text(context.select(
              (CustomPageModel customPageModel) => customPageModel.currTitle!,
            )),
          ),
          body: (BuildContext context) => const Center(child: Text("1")),
          fab: _fabBuilder,
        );

  static Widget _fabBuilder(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          await _dialogBuilder(context);
        },
        child: const Icon(Icons.add),
        tooltip: "Add a password",
      );

  static Future<void> _dialogBuilder(BuildContext context) async {
    final Map<String, GlobalKey<FormState>> formKeys = {
      "submit": GlobalKey<FormState>(),
      "generate": GlobalKey<FormState>(),
    };

    late final TextEditingController dialogController = TextEditingController();

    late final getSettings;

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
      "length": (BuildContext context) => CustomTextSliderPasswdWithProvider(
            labelText: "Password",
            hintText: "Enter password",
            text: "Length",
            value: 12,
            validator: (String? value) {
              // TODO compare value and settings, reject if inconsistent

              Validator validator = getSettings(value);

              switch (context.read<VaultDialogModel>().currForm) {
                case "submit":
                  if (!validator.validatePasswd()) {
                    return validator.messages
                        .map((String str) => "* " + str)
                        .join("\n");
                  }
                  return null;

                case "generate":
                  if (!validator.validateSumSettings()) {
                    return validator.messages
                        .map((String str) => "* " + str)
                        .join("\n");
                  }
                  return null;

                default:
              }
              return null;
            },
          ),
    };

    getSettings = (String text) {
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

      int length = dialogOptions["length"]!(context).sliderModel.value.toInt();
      settings.remove("length");

      print("settings: $settings");
      print("settingsAllowed: $settingsAllowed");

      return Validator(
          allowedChars: settingsAllowed,
          numChars: settings,
          length: length,
          text: text);
    };

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

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) => ChangeNotifierProvider(
        create: (_) => VaultDialogModel(),
        builder: (context, _) => GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AlertDialog(
            content: SingleChildScrollView(
              child: Wrap(
                children: [
                  Form(
                    key: formKeys[context.select(
                        (VaultDialogModel vaultDialogModel) =>
                            vaultDialogModel.currForm)],
                    child: Column(
                      children: <Widget>[
                        dialogOptions["length"](context),
                        AnimatedSize(
                          alignment: Alignment.topCenter,
                          curve: Curves.easeIn,
                          duration: const Duration(milliseconds: 200),
                          child: Offstage(
                            offstage: context.select(
                                (VaultDialogModel vaultDialogModel) =>
                                    !vaultDialogModel.isSettingsVisible),
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
        ),
      ),
    );
  }
}
