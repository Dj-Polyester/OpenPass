import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  const CustomSnackbar({
    Key? key,
    required this.content,
  }) : super(
          key: key,
          content: content,
          duration: const Duration(seconds: 1),
        );

  final Widget content;
}
