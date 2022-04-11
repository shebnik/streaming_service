import 'package:flutter/material.dart';
import 'package:streaming_service/services/auth_service.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artists/artists_list.dart';
import 'package:streaming_service/ui/widgets/app_app_bar.dart';

class ArtistsTab extends StatefulWidget {
  const ArtistsTab({Key? key}) : super(key: key);

  @override
  _ArtistsTabState createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<ArtistsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppAppBar(
        title: "Artists",
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'logout') {
                AuthService.signOut();
              }
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem(
                value: 'logout',
                child: Text('Log out'),
              ),
            ],
          ),
        ],
      ),
      body: const ArtistsList(
        loadArtists: NapsterService.getTopArtists,
      ),
    );
  }
}
