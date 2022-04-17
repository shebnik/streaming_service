import 'package:flutter/material.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

extension AuthChecker on String {
  bool isEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
  
  bool isPassword() {
    return length > 5;
  }
}

extension ShowSnackBar on String {
  void showAsSnackBarMessage() {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(this),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

extension WidgetExtensions on Widget {
  Future<T?> showWidgetAsDialog<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}