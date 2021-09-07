import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/vault_dialog.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/api/custom_animated_size.dart';
import 'package:polipass/widgets/api/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/api/custom_text_checkbox.dart';
import 'package:polipass/widgets/api/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_secret.dart';
import 'package:polipass/utils/validator.dart';

class EditCustomPasswordModel extends ChangeNotifier {
  EditCustomPasswordModel({
    this.settingsHeightMax = 400,
    required this.globalPasskey,
    required this.globalPasskeyItem,
  }) : settingsHeight = settingsHeightMax;
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

  late String _formKeySwitch;
  String get formKeySwitch => _formKeySwitch;
  set formKeySwitch(String value) {
    _formKeySwitch = value;
    notifyListeners();
  }

  PassKey? globalPasskey;
  PassKeyItem? globalPasskeyItem;
  PassKeyModel globalPassKeyModel = PassKeyModel();

  late CustomTextSecretWithProvider dialogKeyInput =
      CustomTextSecretWithProvider(
    passKeyModel: globalPassKeyModel,
    labelText: "Password",
    hintText: "Enter password",
    getSettings: getSettings,
    inputText: globalPasskeyItem!.value,
  );

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

    int length = dialogKeyInput.sliderModel.value.toInt();

    return {
      "length": length,
      "numChars": numChars,
      "allowedChars": allowedChars,
    };
  }

  //dialog widgets

  late final Map<String, dynamic> dialogButtons = {
    //SUBMIT
    "submit": (BuildContext context) => TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            globalPassKeyModel.formKeySwitch = "submit";

            // Validate returns true if the form is valid, or false otherwise.
            if (globalPassKeyModel.formKey.currentState!.validate()) {
              // submit new keys.

              globalPasskeyItem!.value = context
                  .read<EditCustomPasswordModel>()
                  .dialogKeyInput
                  .textPasswdModel
                  .controller
                  .text;

              // quit
              Navigator.pop(context, globalPasskeyItem);
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
            context.read<EditCustomPasswordModel>().toggleVisibility();
          },
          child: const Text("Settings"),
        ),
  };
}

class EditCustomPassword extends StatelessWidget {
  EditCustomPassword({
    Key? key,
    required this.globalPasskey,
    required this.globalPasskeyItem,
  }) : super(key: key);

  PassKey? globalPasskey;
  PassKeyItem globalPasskeyItem;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditCustomPasswordModel(
        globalPasskey: globalPasskey,
        globalPasskeyItem: globalPasskeyItem,
      ),
      builder: (context, _) => AlertDialog(
        content: SingleChildScrollView(
          child: Wrap(
            children: [
              Form(
                key: context
                    .read<EditCustomPasswordModel>()
                    .globalPassKeyModel
                    .formKey,
                child: Selector<EditCustomPasswordModel,
                    CustomTextSecretWithProvider>(
                  selector: (_, vaultPasswordModel) =>
                      vaultPasswordModel.dialogKeyInput,
                  builder: (_, dialogKeyInput, __) => Column(
                    children: [
                          dialogKeyInput,
                        ].cast<Widget>() +
                        context
                            .read<EditCustomPasswordModel>()
                            .dialogButtons
                            .entries
                            .map((e) => SizedBox(
                                  width: double.infinity,
                                  child: e.value!(context),
                                ))
                            .toList()
                            .cast<Widget>() +
                        [
                          CustomAnimatedSize(
                            child: Selector<EditCustomPasswordModel, bool>(
                              selector: (_, vaultPasswordModel) =>
                                  vaultPasswordModel.isSettingsVisible,
                              builder: (_, isSettingsVisible, __) => Offstage(
                                offstage: !isSettingsVisible,
                                child: Column(
                                  children: context
                                      .read<EditCustomPasswordModel>()
                                      .dialogOptions
                                      .entries
                                      .map((e) => e.value)
                                      .toList()
                                      .cast<Widget>(),
                                ),
                              ),
                            ),
                          ),
                        ],
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
