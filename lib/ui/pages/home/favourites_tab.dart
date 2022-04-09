import 'package:flutter/material.dart';
import 'package:streaming_service/ui/widgets/app_app_bar.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({Key? key}) : super(key: key);

  @override
  _FavouritesTabState createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const Scaffold(
      appBar: AppAppBar(
        title: "Favourites",
      ),
    );
  }
}
