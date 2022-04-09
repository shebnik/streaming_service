import 'package:flutter/material.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.height = 50,
    this.width,
    this.text = "",
    this.onPressed,
  }) : super(key: key);

  final double height;
  final double? width;
  final String text;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      minWidth: width,
      color: AppTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(text),
      onPressed: onPressed as void Function()?,
    );
  }
}
