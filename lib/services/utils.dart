import 'package:flutter/material.dart';

class Utils {
  static bool isEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static openBottomSheet(BuildContext context, Widget bottomSheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: bottomSheet,
      ),
    );
  }

  static Future<bool?> openDialog(BuildContext context, Widget dialog) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
