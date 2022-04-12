import 'package:flutter/material.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';


final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class Utils {
  static bool isEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static void openBottomSheet(BuildContext context, Widget bottomSheet) {
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

  static void openSnackBar(String message) {
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        // snackStyle: SnackStyle.GROUNDED,
        // snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 5),
        // mainButton: TextButton(
        //   onPressed: onPressed ?? () => Get.back(),
        //   child: Text(
        //     buttonText ?? 'OK',
        //     style: const TextStyle(
        //       color: AppTheme.primary,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
