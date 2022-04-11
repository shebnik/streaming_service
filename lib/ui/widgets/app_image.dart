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
  void initState() {
    super.initState();
    // unawaited(loadImage());
  }

  // Future<void> loadImage() async {
  //   try {
  //     final bytes =
  //         (await NetworkAssetBundle(Uri.parse(widget.url)).load(widget.url))
  //             .buffer
  //             .asUint8List();
  //     image = Image.memory(
  //       bytes,
  //       fit: BoxFit.cover,
  //     );
  //     setState(() {});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // if (image != null) {
    //   return image!;
    // } else {
    //   return SizedBox.expand(
    //     child: Container(
    //       color: AppTheme.grayDeep,
    //     ),
    //   );
    // }
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
