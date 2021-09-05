import 'package:flutter/material.dart';

class CustomAnimatedSize extends StatelessWidget {
  const CustomAnimatedSize({
    Key? key,
    this.duration = 200,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key);

  final int duration;
  final Widget? child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.center,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: duration),
      child: child,
    );
  }
}
