import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/vault_dialog.dart';
import 'package:polipass/pages/vault/edit_custom_password.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/widgets/custom_animated_size.dart';
import 'package:polipass/widgets/custom_checkbox.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/custom_text_checkbox.dart';
import 'package:polipass/widgets/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_secret.dart';
import 'package:polipass/utils/validator.dart';

class AddCustomDialog extends StatelessWidget {
  AddCustomDialog({
    Key? key,
    required this.globalPasskey,
  }) : super(key: key);

  PassKey? globalPasskey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CustomCheckboxWithProvider customCheckboxWithProvider =
      CustomCheckboxWithProvider();

  @override
  Widget build(BuildContext context) {
    CustomTextWithProvider passkeyNameInput = CustomTextWithProvider(
      labelText: "Name",
      hintText: "Enter name",
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        validators: [(v) => v.validateInput()],
      ),
    );

    return AlertDialog(
      content: Wrap(children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              passkeyNameInput,
              Row(
                children: [
                  customCheckboxWithProvider,
                  const Text("Is a secret key?"),
                ],
              ),
              TextButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    //submit the info to the hive database.

                    String name = passkeyNameInput.textModel.controller.text;
                    bool isSecret =
                        customCheckboxWithProvider.checkboxModel.value;

                    PassKeyItem passkeyItem = PassKeyItem(
                      name: name,
                      value: "",
                      isSecret: isSecret,
                    );
                    //CAN BE NULL
                    PassKeyItem? tmp = await showDialog<PassKeyItem>(
                      context: context,
                      builder: (_) => EditCustomPassword(
                        globalPasskey: globalPasskey,
                        globalPasskeyItem: passkeyItem,
                      ),
                    );

                    tmp ??= passkeyItem;

                    print("passkeyItem: $tmp");

                    // quit
                    Navigator.pop(context, tmp);
                    Fluttertoast.showToast(
                      msg: "Added the key with name $name",
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                },
                child: const Text("Submit"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor:
                      MaterialStateProperty.all<Color>(const Color(0x33FFFFFF)),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
