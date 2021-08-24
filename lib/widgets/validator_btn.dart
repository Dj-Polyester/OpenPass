import 'package:flutter/material.dart';

class ValidatorBtn extends StatelessWidget {
  const ValidatorBtn({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Validate returns true if the form is valid, or false otherwise.
        if (formKey.currentState!.validate()) {
          // TODO call a server or save the information in a database.

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Processing Data")),
          );
        }
      },
      child: const Text("Submit"),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFFFFF)),
      ),
    );
  }
}
