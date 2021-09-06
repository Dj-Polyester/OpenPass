import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/add_custom_password.dart';
import 'package:polipass/pages/vault/edit_custom_password.dart';
import 'package:polipass/pages/vault/vault_dialog.dart';
import 'package:polipass/utils/validator.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:polipass/widgets/custom_text_digit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_text_style.dart';

class CustomVaultTextWithProvider extends StatelessWidget {
  CustomVaultTextWithProvider({
    Key? key,
    required this.vaultDialogModel,
    required this.globalPasskey,
    this.validator,
    this.labelText = "",
    this.hintText = "",
    this.inputText,
    this.onChanged,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.isSecret = true,
    this.hasDelete = true,
  }) : super(key: key);

  VaultDialogModel vaultDialogModel;
  PassKey? globalPasskey;
  bool isSecret, hasDelete;

  Color? fillColor, focusColor, hoverColor;
  String? inputText;
  String? Function(String?)? validator;
  Function(String)? onChanged;

  final String labelText, hintText;

  late CustomTextModel textModel = CustomTextModel(text: inputText);

  @override
  Widget build(BuildContext context) {
    validator ??= (String? value) => Validator(text: value).validateAll(
          value: value,
          validators: [(v) => v.validateInput()],
        );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: textModel),
      ],
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            validator: validator,
            labelText: labelText,
            hintText: hintText,
            onChanged: onChanged,
            fillColor: fillColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    PassKeyItem passKeyitem = PassKeyItem(
                        name: labelText,
                        value: textModel.controller.text,
                        isSecret: isSecret);

                    PassKeyItem? tmp = await showDialog<PassKeyItem>(
                      context: context,
                      builder: (_) => EditCustomPassword(
                        globalPasskey: globalPasskey,
                        globalPasskeyItem: passKeyitem,
                      ),
                    );
                    if (tmp != null) {
                      vaultDialogModel.addCustomInput(passKeyitem);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  tooltip: "Edit",
                ),
                Visibility(
                  visible: hasDelete,
                  child: IconButton(
                    onPressed: () async {
                      vaultDialogModel.deleteCustomInput(labelText);
                    },
                    icon: const Icon(Icons.delete),
                    tooltip: "Delete",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
