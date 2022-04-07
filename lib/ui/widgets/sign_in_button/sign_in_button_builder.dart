import 'package:flutter/material.dart';

@immutable
class SignInButtonBuilder extends StatelessWidget {
  final Widget? icon;
  final String text;
  final double fontSize;
  final Color textColor,
      iconColor,
      backgroundColor,
      splashColor,
      highlightColor;
  final Function onPressed;
  final double elevation;
  final double? width;

  const SignInButtonBuilder({
    Key? key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
    this.icon,
    this.fontSize = 14.0,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.splashColor = Colors.white30,
    this.highlightColor = Colors.white30,
    this.elevation = 2.0,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      key: key,
      height: 50.0,
      elevation: elevation,
      padding: const EdgeInsets.all(0),
      color: backgroundColor,
      onPressed: onPressed as void Function()?,
      splashColor: splashColor,
      highlightColor: highlightColor,
      child: _getButtonChild(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
    );
  }

  Widget _getButtonChild(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: icon,
        ),
        Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
            ),
          ),
        ),
      ],
    );
  }
}
