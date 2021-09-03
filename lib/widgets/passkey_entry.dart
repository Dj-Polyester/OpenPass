import 'package:flutter/material.dart';
import 'package:polipass/models/passkey.dart';

class PassKeyEntry extends StatelessWidget {
  const PassKeyEntry({
    Key? key,
    required this.passkey,
  }) : super(key: key);

  final PassKey passkey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(passkey.desc),
        Text(passkey.username ?? ""),
        Text(passkey.email ?? ""),
        Text(passkey.password),
      ],
    );
  }
}
