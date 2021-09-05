import 'package:fluttertoast/fluttertoast.dart';
import 'package:polipass/models/passkey.dart';
import 'package:polipass/utils/generator.dart';
import 'package:polipass/utils/globals.dart';
import 'package:polipass/utils/validator.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:polipass/widgets/custom_text_digit.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_slider.dart';
import 'package:polipass/widgets/custom_text_slider.dart';
import 'package:polipass/widgets/custom_text_style.dart';

class CustomTextSecretWithProvider extends StatelessWidget {
  CustomTextSecretWithProvider({
    Key? key,
    required this.passKeyModel,
    this.validator,
    this.getSettings,
    this.labelText = "",
    this.hintText = "",
    this.text = "Length",
    this.min = 0,
    this.max = 99,
    this.value = 12,
    this.inputText,
  }) : super(key: key);

  final String? inputText;
  late String? Function(String?)? validator;
  final Map<String, dynamic> Function()? getSettings;

  final String labelText, hintText, text;
  final double min, max, value;

  late CustomSliderModel sliderModel = CustomSliderModel(value: value);
  late CustomTextDigitModel textDigitModel = CustomTextDigitModel(value: value);
  late CustomTextModel textPasswdModel = CustomTextModel(text: inputText);
  final PassKeyModel passKeyModel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sliderModel),
        ChangeNotifierProvider.value(value: textDigitModel),
        ChangeNotifierProvider.value(value: textPasswdModel),
        ChangeNotifierProvider.value(value: passKeyModel),
      ],
      builder: (context, _) {
        return CustomTextSecret(
          sliderTextLabel: text,
          min: min,
          max: max,
          validator: validator,
          getSettings: getSettings,
          labelText: labelText,
          hintText: hintText,
        );
      },
    );
  }
}

class CustomTextSecret extends StatelessWidget {
  CustomTextSecret({
    Key? key,
    this.validator,
    this.getSettings,
    this.labelText = "",
    this.hintText = "",
    this.sliderTextLabel = "",
    this.min = 0,
    this.max = 99,
  }) : super(key: key);

  String? Function(String?)? validator;
  final Map<String, dynamic> Function()? getSettings;
  final String labelText, hintText, sliderTextLabel;
  double min, max;

  @override
  Widget build(BuildContext context) {
    validator ??= (String? value) => Validator.fromMap(
          map: getSettings!(),
          text: value,
        ).validateAll(
          value: value,
          conditions: [
            context.read<PassKeyModel>().formKeySwitch == "submit",
            context.read<PassKeyModel>().formKeySwitch == "generate",
          ],
          validators: [
            (v) => v.validatePasswd(),
            (v) => v.validateSumSettings()
          ],
        );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            suffixIcon: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                // dialogOptions["length"]!.textPasswdModel.focusNode.unfocus();
                context.read<PassKeyModel>().formKeySwitch = "generate";
                // formKeySwitch = "generate";

                // Validate returns true if the form is valid, or false otherwise.
                if (context
                    .read<PassKeyModel>()
                    .formKey
                    .currentState!
                    .validate()) {
                  Generator generator = Generator.fromMap(getSettings!());

                  context.read<CustomTextModel>().controller.text =
                      generator.generate();

                  Fluttertoast.showToast(
                    msg: "Password generated",
                    toastLength: Toast.LENGTH_SHORT,
                  );
                }
              },
              icon: const Icon(Icons.refresh),
              tooltip: "generate",
              splashRadius: context
                  .select((GlobalModel globalmodel) => globalmodel.fontSize),
            ),
            validator: validator,
            labelText: labelText,
            hintText: hintText,
            onChanged: (String value) {
              double tmpval = context
                  .read<CustomTextModel>()
                  .controller
                  .text
                  .length
                  .toDouble();
              context.read<CustomSliderModel>().setValue(tmpval);
              context.read<CustomTextDigitModel>().setTextFromDouble(tmpval);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextSlider(
            label: sliderTextLabel,
            min: min,
            max: max,
          ),
        ),
      ],
    );
  }
}
