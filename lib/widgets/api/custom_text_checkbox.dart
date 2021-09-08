import 'package:flutter/material.dart';
import 'package:polipass/pages/vault/vault.dart';
import 'package:polipass/widgets/api/custom_checkbox.dart';
import 'package:provider/provider.dart';

class CustomTextCheckboxWithProvider extends StatelessWidget {
  CustomTextCheckboxWithProvider({
    Key? key,
    required this.text1,
    this.text2,
  }) : super(key: key);

  final String text1;
  final String? text2;

  late CustomCheckboxModel checkboxModel = CustomCheckboxModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: checkboxModel,
      builder: (context, _) {
        return CustomTextCheckbox(
          text1: text1,
          text2: text2,
        );
      },
    );
  }
}

class CustomTextCheckbox extends StatelessWidget {
  CustomTextCheckbox({
    Key? key,
    required this.text1,
    this.text2,
  }) : super(key: key);

  final String text1;
  final String? text2;
  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckbox(),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: text1,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: (text2 == null)
                  ? null
                  : [
                      TextSpan(
                        text: text2!,
                        style: const TextStyle(fontFamily: "JetBrainsMono"),
                      ),
                    ],
            ),
          ),
        ),
      ],
    );
  }
}
