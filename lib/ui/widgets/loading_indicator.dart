import 'package:flutter/material.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(color: AppTheme.blackMatte),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}
