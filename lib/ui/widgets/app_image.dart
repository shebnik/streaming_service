import 'package:flutter/material.dart';

import 'package:streaming_service/ui/theme/app_theme.dart';

class AppImage extends StatefulWidget {
  const AppImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  Image? image;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.url,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : splash,
      errorBuilder: (_, __, ___) => splash,
    );
  }

  Widget splash = SizedBox.expand(
    child: Container(
      color: AppTheme.grayDeep,
    ),
  );
}
