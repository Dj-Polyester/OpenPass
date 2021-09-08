import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/pages/vault/dialogs/edit_custom_key.dart';
import 'package:polipass/pages/vault/dialogs/vault_dialog.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/utils/validator.dart';
import 'package:polipass/widgets/api/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CustomVaultTextWithProvider extends StatelessWidget {
  CustomVaultTextWithProvider({
    Key? key,
    required this.vaultDialogModel,
    required this.globalPasskey,
    required this.name,
    this.validator,
    this.labelText = "",
    this.hintText = "",
    this.inputText,
    this.onChanged,
    this.textStyle,
    this.isSecret = true,
    this.hasDelete = true,
  }) : super(key: key);

  TextStyle? textStyle;
  VaultDialogModel vaultDialogModel;
  final PassKey? globalPasskey;
  bool isSecret, hasDelete;

  String? inputText;
  String? Function(String?)? validator;
  Function(String)? onChanged;

  final String labelText, hintText, name;

  late CustomTextModel textModel = CustomTextModel(text: inputText);

  @override
  Widget build(BuildContext context) {
    validator ??= (String? value) => Validator(text: value).validateAll(
          value: value,
          validators: [(v) => v.validatePassword()],
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
            textStyle: textStyle,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    PassKeyItem passKeyitem = PassKeyItem(
                        name: name,
                        value: textModel.controller.text,
                        isSecret: isSecret);

                    PassKeyItem? tmp = await showDialog<PassKeyItem>(
                      context: context,
                      builder: (_) => EditCustomKey(
                        globalPasskey: globalPasskey,
                        globalPasskeyItem: passKeyitem,
                      ),
                    );
                    if (tmp != null) {
                      vaultDialogModel.addCustomInput(passKeyitem);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  tooltip: Lang.tr("Edit"),
                ),
                Visibility(
                  visible: hasDelete,
                  child: IconButton(
                    onPressed: () async {
                      vaultDialogModel.deleteCustomInput(labelText);
                      Fluttertoast.showToast(
                        msg: Lang.tr("Deleted the key"),
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    },
                    icon: const Icon(Icons.delete),
                    tooltip: Lang.tr("Delete"),
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
