import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  const IconBtn({
    Key? key,
    required this.icon,
    this.message = "",
    this.color,
    this.splashColor = const Color(0xFFAAAAAA),
    this.frameSize = 30,
    this.whFactor = 0.6,
    this.padding = const EdgeInsets.all(0),
    required this.onTap,
  }) : super(key: key);
  final double frameSize, whFactor;
  final EdgeInsets padding;
  final Icon icon;
  final String message;
  final Color splashColor;
  final Color? color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Tooltip(
        message: message,
        child: ClipOval(
          child: Material(
            color: color,
            child: InkWell(
              splashColor: splashColor,
              child: SizedBox(
                width: frameSize,
                height: frameSize,
                child: FractionallySizedBox(
                  widthFactor: whFactor,
                  heightFactor: whFactor,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: icon,
                  ),
                ),
              ),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
