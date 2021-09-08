import 'package:flutter/material.dart';
import 'package:polipass/utils/globals.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key, this.height}) : super(key: key);

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      indent: Globals.sidePadding,
      endIndent: Globals.sidePadding,
    );
  }
}
