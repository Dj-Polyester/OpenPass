import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/dialogs/vault_dialog.dart';
import 'package:polipass/pages/vault/dialogs/edit_custom_key.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_animated_size.dart';
import 'package:polipass/widgets/api/custom_button.dart';
import 'package:polipass/widgets/api/custom_checkbox.dart';
import 'package:polipass/widgets/api/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/api/custom_text_checkbox.dart';
import 'package:polipass/widgets/api/custom_text_checkbox_slider.dart';
import 'package:polipass/widgets/custom_text_secret.dart';
import 'package:polipass/utils/validator.dart';

class AddCustomKey extends StatelessWidget {
  AddCustomKey({
    Key? key,
    required this.globalPasskey,
  }) : super(key: key);

  PassKey? globalPasskey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CustomCheckboxWithProvider customCheckboxWithProvider =
      CustomCheckboxWithProvider();

  @override
  Widget build(BuildContext context) {
    CustomTextWithProvider singleNameInput = CustomTextWithProvider(
      labelText: Lang.tr("Name"),
      hintText: Lang.tr("Enter a name"),
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
              singleNameInput,
              PrimaryButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    //submit the info to the hive database.

                    String name = singleNameInput.textModel.controller.text;

                    PassKeyItem passkeyItem = PassKeyItem(
                      name: name,
                      value: "",
                    );
                    //CAN BE NULL
                    PassKeyItem? tmp = await showDialog<PassKeyItem>(
                      context: context,
                      builder: (_) => EditCustomKey(
                        globalPasskey: globalPasskey,
                        globalPasskeyItem: passkeyItem,
                      ),
                    );

                    tmp ??= passkeyItem;

                    // print("passkeyItem: $tmp");

                    // quit
                    Navigator.pop(context, tmp);
                  }
                },
                child: Text(Lang.tr("Submit")),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
