import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/db/db.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_checkbox.dart';
import 'package:polipass/widgets/api/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/validator.dart';

class SingleInputDialog extends StatelessWidget {
  SingleInputDialog({Key? key}) : super(key: key);

  void Function(BuildContext, String)? callback;

  PassKey? globalPasskey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CustomCheckboxWithProvider customCheckboxWithProvider =
      CustomCheckboxWithProvider();

  @override
  Widget build(BuildContext context) {
    callback ??= (context, name) => Navigator.pop(context, name);
    CustomTextWithProvider singleNameInput = CustomTextWithProvider(
      labelText: Lang.tr("File name"),
      hintText: Lang.tr("Enter a file name"),
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
              TextButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    String name = singleNameInput.textModel.controller.text;
                    Navigator.pop(context, name);
                  }
                },
                child: Text(Lang.tr("Submit")),
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
