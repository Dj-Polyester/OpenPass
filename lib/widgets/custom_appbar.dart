import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key, this.title}) : super(key: key);

  final Text? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(title: title);
  }
}
