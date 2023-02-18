import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/lang.dart';
import 'package:polipass/widgets/api/custom_button.dart';
import 'package:polipass/widgets/api/custom_checkbox.dart';
import 'package:polipass/widgets/api/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:polipass/utils/validator.dart';

class SingleInputPrompt extends StatelessWidget {
  SingleInputPrompt({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  void Function(BuildContext, String)? callback;
  bool obscureText;

  PassKey? globalPasskey;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String labelText, hintText;

  CustomCheckboxWithProvider customCheckboxWithProvider =
      CustomCheckboxWithProvider();

  @override
  Widget build(BuildContext context) {
    callback ??= (context, name) => Navigator.pop(context, name);
    CustomTextWithProvider singleNameInput = CustomTextWithProvider(
      labelText: labelText,
      hintText: hintText,
      validator: (String? value) => Validator(text: value).validateAll(
        value: value,
        validators: [(v) => v.validateInput()],
      ),
      obscureText: obscureText,
    );

    return Wrap(
      children: [
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
                    String name = singleNameInput.textModel.controller.text;
                    Navigator.pop(context, name);
                  }
                },
                child: Text(Lang.tr("Submit")),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
