import 'package:flutter/material.dart';

class AreYouSureDialog extends StatelessWidget {
  const AreYouSureDialog({
    Key? key,
    required this.message
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () => Navigator.of(context).pop(),
    );
    Widget continueButton = TextButton(
      child: const Text("Remove"),
      onPressed: () => Navigator.of(context).pop(true),
    );

    return AlertDialog(
      title: const Text("Are you sure?"),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}
