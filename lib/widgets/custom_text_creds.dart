import 'package:flutter/material.dart';
import 'package:polipass/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class CustomTextCredsWithProvider extends StatelessWidget {
  CustomTextCredsWithProvider({
    Key? key,
    this.validator,
    this.labelText = "",
    this.hintText = "",
  }) : super(key: key);

  String? Function(String?)? validator;

  final String labelText, hintText;

  late CustomTextModel textCredModel = CustomTextModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: textCredModel),
      ],
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomText(
            validator: validator,
            labelText: labelText,
            hintText: hintText,
          ),
        );
      },
    );
  }
}
