import 'package:flutter/material.dart';
import 'package:polipass/utils/custom_page.dart';
import 'package:polipass/widgets/custom_checkbox.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_slider.dart';
import 'package:polipass/widgets/custom_text_slider_passwd.dart';
import 'package:polipass/widgets/custom_text_style.dart';
import 'package:polipass/widgets/validator.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
    late final _dialogFormKey = GlobalKey<FormState>();
    late final TextEditingController _dialogController =
        TextEditingController();

    late final getSettings;

    late final Map<String, dynamic> _dialogOptions = {
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
          Validator validator = getSettings();
          validator.text = value;

          bool valid = validator.validatePasswd();

          if (!valid) {
            return validator.messages
                .map((String str) => "* " + str)
                .join("\n");
          }
          // if (value == null || value.isEmpty) {
          //   return 'Please enter some text';
          // }
          return null;
        },
      ),
    };

    getSettings = () {
      Map<String, int> settings = {};
      Map<String, bool> settingsAllowed = {};

      for (String key in _dialogOptions.keys) {
        dynamic item = _dialogOptions[key];

        if (item is CustomTextCheckboxWithProvider ||
            item is CustomTextCheckboxSliderWithProvider) {
          settingsAllowed[key] = item.checkboxModel.value;
        }
        if (item is CustomTextSliderPasswdWithProvider ||
            item is CustomTextCheckboxSliderWithProvider) {
          settings[key] = item.sliderModel.value.toInt();
        }
      }

      int length = settings["length"]!;
      settings.remove("length");

      print("settings: $settings");
      print("settingsAllowed: $settingsAllowed");

      return Validator(
          allowedChars: settingsAllowed, numChars: settings, length: length);
    };

    //dialog widgets
    TextButton //
        submitBtn = TextButton(
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_dialogFormKey.currentState!.validate()) {
              // TODO call a server or save the information in a database.

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Processing Data")),
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
        genBtn = TextButton(
          onPressed: () {},
          child: const Text("Generate"),
        );
    TextButton settingsBtn(BuildContext context) => TextButton(
          onPressed: () {
            context.read<VaultDialogModel>().toggleVisibility();
          },
          child: const Text("Settings"),
        );

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
                    key: _dialogFormKey,
                    child: Column(
                      children: <Widget>[
                        _dialogOptions["length"],
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
                                _dialogOptions["az"],
                                _dialogOptions["AZ"],
                                _dialogOptions["09"],
                                _dialogOptions["special"],
                                _dialogOptions["ambiguous"],
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: double.infinity, child: submitBtn),
                        SizedBox(width: double.infinity, child: genBtn),
                        SizedBox(
                            width: double.infinity,
                            child: settingsBtn(context)),
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
