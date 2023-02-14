import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/dialogs/passwd_prompt.dart';
import 'package:polipass/pages/vault/dialogs/single_input_prompt.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_button.dart';
import 'package:polipass/widgets/api/custom_divider.dart';
import 'package:polipass/widgets/api/custom_snackbar.dart';
import 'package:polipass/widgets/api/custom_text.dart';
import 'package:polipass/widgets/custom_vault_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/validator.dart';
import 'package:tuple/tuple.dart';

class VaultDialogModel extends ChangeNotifier {
  VaultDialogModel({
    required this.globalPasskey,
  });

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool vaultDialogFlag = true;
  void notifyVaultDialog() {
    vaultDialogFlag = !vaultDialogFlag;
    notifyListeners();
  }

  final PassKey? globalPasskey;
  // PassKeyModel globalPassKeyModel = PassKeyModel();

  late final Map<String, dynamic> dialogInputs = {
    "desc": CustomTextWithProvider(
      labelText: Lang.tr("Description"),
      hintText: Lang.tr("Enter a description"),
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        conditions: [globalPasskey == null, true],
        validators: [(v) => v.validateDesc(), (v) => v.validateInput()],
      ),
      inputText: (globalPasskey == null) ? null : globalPasskey!.desc,
    ),
    "username": CustomTextWithProvider(
      labelText: Lang.tr("Username (optional)"),
      hintText: Lang.tr("Enter a username"),
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        conditions: [true],
        validators: [(v) => v.validateUsername()],
      ),
      inputText: (globalPasskey == null) ? null : globalPasskey!.username,
    ),
    "email": CustomTextWithProvider(
      labelText: Lang.tr("Email (optional)"),
      hintText: Lang.tr("Enter an email"),
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        conditions: [value!.isNotEmpty],
        validators: [(v) => v.validateEmailAll()],
      ),
      inputText: (globalPasskey == null) ? null : globalPasskey!.email,
    ),
    "password": passwordInputs(
      this,
      globalPasskey,
      (globalPasskey == null) ? null : globalPasskey!.password,
    ),
  };

  CustomVaultTextWithProvider passwordInputs(VaultDialogModel vaultDialogModel,
          PassKey? globalPasskey, String? inputText) =>
      CustomVaultTextWithProvider(
        name: "password",
        vaultDialogModel: vaultDialogModel,
        globalPasskey: globalPasskey,
        labelText: Lang.tr("Password"),
        hintText: Lang.tr("Enter a password"),
        inputText: inputText,
        isSecret: true,
        hasDelete: false,
      );

  late final Map<String, CustomVaultTextWithProvider> dialogInputsOther =
      (globalPasskey == null)
          ? {}
          : globalPasskey!.other
              .map((String key, PassKeyItem value) => MapEntry(
                  key,
                  CustomVaultTextWithProvider(
                    name: value.name,
                    vaultDialogModel: this,
                    globalPasskey: globalPasskey,
                    labelText: value.name,
                    hintText: Lang.tr("Enter a key"),
                    inputText: value.value,
                    isSecret: value.isSecret,
                  )));

  void addCustomInput(PassKeyItem passkeyItem) {
    if (passkeyItem.name == "password") {
      dialogInputs["password"] = passwordInputs(
        this,
        globalPasskey,
        passkeyItem.value,
      );
    } else {
      dialogInputsOther[passkeyItem.name] = CustomVaultTextWithProvider(
        name: passkeyItem.name,
        vaultDialogModel: this,
        globalPasskey: globalPasskey,
        labelText: passkeyItem.name,
        hintText: Lang.tr("Enter a key"),
        inputText: passkeyItem.value,
        isSecret: passkeyItem.isSecret,
      );
    }

    notifyVaultDialog();
  }

  void deleteCustomInput(String name) {
    dialogInputsOther.remove(name);

    notifyVaultDialog();
  }

  //dialog widgets

  late final Map<String, dynamic> dialogButtons = {
    "addCustom": (BuildContext context) => SecondaryButton(
          onPressed: () async {
            String? keyname = await showDialog<String>(
              context: context,
              builder: (_) => AlertDialog(
                  content: SingleInputPrompt(
                labelText: Lang.tr("Enter a name"),
                hintText: Lang.tr("Name"),
              )),
            );

            if (keyname != null) {
              PassKeyItem passkeyItem = PassKeyItem(name: keyname, value: "");

              PassKeyItem? tmp = await showDialog<PassKeyItem>(
                context: context,
                builder: (_) => AlertDialog(
                  content: EditCustomKey(
                    globalPasskey: globalPasskey,
                    globalPasskeyItem: passkeyItem,
                  ),
                ),
              );

              if (tmp != null) {
                addCustomInput(tmp);
              }
            }
          },
          child: Text(Lang.tr("+ Add a custom key")),
        ),
    //SUBMIT
    "submit": (BuildContext context) => TextButton(
          onPressed: () async {
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
                username: username,
                email: email,
                password: password,
                other: other,
              );

              // print("passkey: $passkey");
              late String snackbarMsg;

              if (globalPasskey == null) {
                //INSERT
                snackbarMsg = "Added the key set with the description %s";
                await KeyStore.insert(context, passkey, passkey.desc);
              } else {
                //UPDATE
                snackbarMsg = "Updated the key set with the description %s";
                await KeyStore.update(
                    context, passkey, passkey.desc, globalPasskey!.desc);
              }

              // quit
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackbar(
                    content: Text(Lang.tr(snackbarMsg, [passkey.desc]))),
              );
            }
          },
          child: Text(Lang.tr("Submit")),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
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
    return ChangeNotifierProvider(
      create: (_) => VaultDialogModel(globalPasskey: globalPasskey),
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
                                const CustomDivider(height: 20),
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
