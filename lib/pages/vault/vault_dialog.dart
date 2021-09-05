import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_animated_size.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_secret.dart';
import 'package:polipass/utils/validator.dart';

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

  bool vaultDialogFlag = true;
  void notifyVaultDialog() {
    vaultDialogFlag = !vaultDialogFlag;
    notifyListeners();
  }
}

class _AddCustomDialog extends StatelessWidget {
  _AddCustomDialog({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CustomTextWithProvider passkeyNameInput = CustomTextWithProvider(
      labelText: "Name",
      hintText: "Enter name",
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        validators: [(v) => v.validateDesc()],
      ),
    );

    return AlertDialog(
      content: Form(
        key: formKey,
        child: Column(
          children: [
            passkeyNameInput,
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();

                // Validate returns true if the form is valid, or false otherwise.
                if (formKey.currentState!.validate()) {
                  // TODO submit the info to the hive database.

                  String name = passkeyNameInput.textModel.controller.text;

                  // quit
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: "Added the key with name $name",
                    toastLength: Toast.LENGTH_SHORT,
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
          ],
        ),
      ),
    );
  }
}

class VaultDialog extends StatelessWidget {
  VaultDialog({Key? key, this.globalPasskey}) : super(key: key);

  PassKey? globalPasskey;
  PassKeyModel globalPassKeyModel = PassKeyModel();

  late final Map<String, dynamic> dialogInputs = {
    "desc": CustomTextWithProvider(
      labelText: "Description",
      hintText: "Enter description",
      validator: (String? value) => Validator.fromMap(
        map: getSettings(),
        text: value,
      ).validateAll(
        value: value,
        conditions: [globalPassKeyModel.formKeySwitch == "submit"],
        validators: [(v) => v.validateDesc()],
      ),
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
      validator: (String? value) => Validator.fromMap(
        map: getSettings(),
        text: value,
      ).validateAll(
        value: value,
        conditions: [
          globalPassKeyModel.formKeySwitch == "submit" && value!.isNotEmpty
        ],
        validators: [(v) => v.validateEmail()],
      ),
      inputText: (globalPasskey == null) ? null : globalPasskey!.email,
    ),
    "password": CustomTextSecretWithProvider(
      passKeyModel: globalPassKeyModel,
      labelText: "Password",
      hintText: "Enter password",
      getSettings: getSettings,
      inputText: (globalPasskey == null) ? null : globalPasskey!.password,
    ),
  };
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
  };

  Map<String, dynamic> getSettings() {
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

    int length = dialogInputs["password"]!.sliderModel.value.toInt();

    return {
      "length": length,
      "numChars": numChars,
      "allowedChars": allowedChars,
    };
  }

  //dialog widgets

  late final Map<String, dynamic> dialogButtons = {
    "addCustom": (BuildContext context) => TextButton(
          onPressed: () async {
            await Vault.dialogBuilder(context,
                builder: (_) => _AddCustomDialog());
          },
          child: const Text("+ Add custom keys"),
        ),
    //SUBMIT
    "submit": (BuildContext context) => TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            globalPassKeyModel.formKeySwitch = "submit";

            // Validate returns true if the form is valid, or false otherwise.
            if (globalPassKeyModel.formKey.currentState!.validate()) {
              // submit the info to the hive database.

              String desc = dialogInputs["desc"].textModel.controller.text,
                  username = dialogInputs["username"].textModel.controller.text,
                  email = dialogInputs["email"].textModel.controller.text,
                  password =
                      dialogInputs["password"].textPasswdModel.controller.text;

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
                key: globalPassKeyModel.formKey,
                child: Column(
                  children: dialogInputs.entries
                          .map((e) => e.value)
                          .toList()
                          .cast<Widget>() +
                      [
                        CustomAnimatedSize(
                          child: Selector<VaultDialogModel, bool>(
                            selector: (_, vaultDialogModel) =>
                                vaultDialogModel.isSettingsVisible,
                            builder: (_, isSettingsVisible, __) => Offstage(
                              offstage: !isSettingsVisible,
                              child: Column(
                                children: dialogOptions.entries
                                    .map((e) => e.value)
                                    .toList()
                                    .cast<Widget>(),
                              ),
                            ),
                          ),
                        ),
                      ] +
                      dialogButtons.entries
                          .map((e) => SizedBox(
                                width: double.infinity,
                                child: e.value!(context),
                              ))
                          .toList()
                          .cast<Widget>(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
