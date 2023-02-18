import 'package:flutter/material.dart';
import 'package:polipass/utils/lang.dart';

enum Confirmation {
  yes,
  no,
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.yes,
    required this.no,
  }) : super(key: key);

  final String title, yes, no;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(Lang.tr(title)),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, Confirmation.yes);
          },
          child: Text(Lang.tr(yes)),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, Confirmation.no);
          },
          child: Text(Lang.tr(no)),
        ),
      ],
    );
  }
}
