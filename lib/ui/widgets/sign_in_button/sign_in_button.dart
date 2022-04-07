// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streaming_service/services/asset_manager.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';

import 'sign_in_button_builder.dart';

enum Buttons {
  Email,
  Google,
  Facebook,
}

class SignInButton extends StatelessWidget {
  final Function onPressed;

  final Buttons button;

  final String? text;

  final EdgeInsets padding;

  final double elevation;

  const SignInButton(
    this.button, {
    required this.onPressed,
    this.padding = const EdgeInsets.all(0),
    this.text,
    this.elevation = 2.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (button) {
      case Buttons.Google:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey("Google"),
          text: text ?? 'Continue with Google',
          textColor: Colors.black,
          icon: SvgPicture.asset(AssetManager.googleLogo),
          backgroundColor: const Color(0xFFFFFFFF),
          onPressed: onPressed,
        );
      case Buttons.Facebook:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey("Facebook"),
          text: text ?? 'Continue with Facebook',
          icon: SvgPicture.asset(AssetManager.facebookLogo),
          backgroundColor: Colors.transparent,
          onPressed: onPressed,
        );
      case Buttons.Email:
      default:
        return SignInButtonBuilder(
          elevation: elevation,
          key: const ValueKey("Email"),
          text: text ?? 'Sign in with Email',
          onPressed: onPressed,
          backgroundColor: AppTheme.primaryColor,
        );
    }
  }
}
