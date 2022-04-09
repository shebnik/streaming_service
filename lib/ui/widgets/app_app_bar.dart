import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget with PreferredSizeWidget {
  const AppAppBar({
    Key? key,
    this.title = "",
    this.actions,
  }) : super(key: key);

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
