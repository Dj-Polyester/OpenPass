import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/add_custom_password.dart';
import 'package:polipass/pages/vault/edit_custom_password.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_animated_size.dart';
import 'package:polipass/widgets/custom_checkbox.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:polipass/widgets/custom_vault_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_secret.dart';
import 'package:polipass/utils/validator.dart';
import 'package:tuple/tuple.dart';

class VaultDialogModel extends ChangeNotifier {
  VaultDialogModel({
    this.settingsHeightMax = 400,
    required this.globalPasskey,
  }) : settingsHeight = settingsHeightMax;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final double settingsHeightMax;
  double settingsHeight;

  bool isSettingsVisible = false;
  void toggleVisibility() {
    isSettingsVisible = !isSettingsVisible;
    settingsHeight = (settingsHeight == 0) ? settingsHeightMax : 0;
    notifyListeners();
  }

  bool vaultDialogFlag = true;
  void notifyVaultDialog() {
    vaultDialogFlag = !vaultDialogFlag;
    notifyListeners();
  }

  PassKey? globalPasskey;
  // PassKeyModel globalPassKeyModel = PassKeyModel();

  late final Map<String, dynamic> dialogInputs = {
    "desc": CustomTextWithProvider(
      labelText: "Description",
      hintText: "Enter description",
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        conditions: [globalPasskey == null, true],
        validators: [(v) => v.validateDesc(), (v) => v.validateInput()],
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
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        conditions: [value!.isNotEmpty],
        validators: [(v) => v.validateEmail()],
      ),
      inputText: (globalPasskey == null) ? null : globalPasskey!.email,
    ),
    "password": CustomVaultTextWithProvider(
      vaultDialogModel: this,
      globalPasskey: globalPasskey,
      labelText: "Password",
      hintText: "Enter password",
      inputText: (globalPasskey == null) ? null : globalPasskey!.password,
      isSecret: true,
      hasDelete: false,
    ),
  };

  late final Map<String, CustomVaultTextWithProvider> dialogInputsOther =
      (globalPasskey == null)
          ? {}
          : globalPasskey!.other
              .map((String key, PassKeyItem value) => MapEntry(
                  key,
                  CustomVaultTextWithProvider(
                    vaultDialogModel: this,
                    globalPasskey: globalPasskey,
                    labelText: value.name,
                    hintText: "Enter key",
                    inputText: value.value,
                    isSecret: value.isSecret,
                  )));

  void addCustomInput(PassKeyItem passkeyItem) {
    dialogInputsOther[passkeyItem.name] = CustomVaultTextWithProvider(
      vaultDialogModel: this,
      globalPasskey: globalPasskey,
      labelText: passkeyItem.name,
      hintText: "Enter key",
      inputText: passkeyItem.value,
      isSecret: passkeyItem.isSecret,
    );

    notifyVaultDialog();
  }

  void deleteCustomInput(String name) {
    dialogInputsOther.remove(name);

    notifyVaultDialog();
  }

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
        numChars[key] = item.checkboxModel.value.toInt();
      }
    }

    int length = dialogInputs["password"]!.checkboxModel.value.toInt();

    return {
      "length": length,
      "numChars": numChars,
      "allowedChars": allowedChars,
    };
  }

  //dialog widgets

  Future Function()? updateVaultInputsView(BuildContext context) {
    return () async {
      PassKeyItem? passKeyitem = await showDialog<PassKeyItem>(
        context: context,
        builder: (_) => AddCustomDialog(globalPasskey: globalPasskey),
      );
      if (passKeyitem != null) {
        addCustomInput(passKeyitem);
      }
    };
  }

  late final Map<String, dynamic> dialogButtons = {
    "addCustom": (BuildContext context) => TextButton(
          onPressed: () async {
            PassKeyItem? passKeyitem = await showDialog<PassKeyItem>(
              context: context,
              builder: (_) => AddCustomDialog(globalPasskey: globalPasskey),
            );
            if (passKeyitem != null) {
              addCustomInput(passKeyitem);
            }
          },
          child: const Text("+ Add custom keys"),
        ),
    //SUBMIT
    "submit": (BuildContext context) => TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();

            // Validate returns true if the form is valid, or false otherwise.
            if (formkey.currentState!.validate()) {
              // submit the info to the hive database.

              String desc = dialogInputs["desc"].textModel.controller.text,
                  username = dialogInputs["username"].textModel.controller.text,
                  email = dialogInputs["email"].textModel.controller.text,
                  password = dialogInputs["password"].textModel.controller.text;

              Map<String, PassKeyItem> other = dialogInputsOther.map(
                  (String key, CustomVaultTextWithProvider value) => MapEntry(
                        key,
                        PassKeyItem(
                          name: key,
                          value: value.textModel.controller.text,
                          isSecret: value.isSecret,
                        ),
                      ));

              PassKey passkey = PassKey(
                desc: desc,
                username: (username == "") ? null : username,
                email: (email == "") ? null : email,
                password: password,
                other: other,
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
        )
  };
}

class VaultDialog extends StatelessWidget {
  VaultDialog({Key? key, this.globalPasskey}) : super(key: key);

  PassKey? globalPasskey;

  @override
  Widget build(BuildContext context) {
    globalPasskey ??= PassKey();
    return ChangeNotifierProvider(
      create: (_) => VaultDialogModel(globalPasskey: globalPasskey!),
      builder: (context, _) => AlertDialog(
        content: SingleChildScrollView(
          child: Wrap(
            children: [
              Form(
                key: context.read<VaultDialogModel>().formkey,
                child: Selector<VaultDialogModel, Tuple3>(
                  selector: (_, vaultDialogModel) => Tuple3(
                      vaultDialogModel.dialogInputs,
                      vaultDialogModel.dialogInputsOther,
                      vaultDialogModel.vaultDialogFlag),
                  builder: (_, tuple, __) => Column(
                    children: tuple.item1.entries
                            .map((e) => e.value)
                            .toList()
                            .cast<Widget>() +
                        ((tuple.item2.isNotEmpty)
                            ? [
                                const Divider(
                                  height: 1,
                                  color: Colors.black54,
                                  indent: Globals.sidePadding,
                                  endIndent: Globals.sidePadding,
                                ),
                              ]
                            : [].cast<Widget>()) +
                        tuple.item2.entries
                            .map((e) => e.value)
                            .toList()
                            .cast<Widget>() +
                        context
                            .read<VaultDialogModel>()
                            .dialogButtons
                            .entries
                            .map((e) => SizedBox(
                                  width: double.infinity,
                                  child: e.value!(context),
                                ))
                            .toList()
                            .cast<Widget>(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
