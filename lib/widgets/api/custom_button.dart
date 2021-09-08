import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFFFFF)),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
        overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFFFFF)),
      ),
    );
  }
}
