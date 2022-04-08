import 'package:flutter/material.dart';
import 'package:streaming_service/models/artist.dart';
import 'package:streaming_service/services/auth_service.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';

import 'artist_detail.dart';

class ArtistsTab extends StatefulWidget {
  const ArtistsTab({Key? key}) : super(key: key);

  @override
  _ArtistsTabState createState() => _ArtistsTabState();
}

class _ArtistsTabState extends State<ArtistsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          toolbarHeight: 80.0,
          title: const Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              'Artists',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
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
      ),
      body: FutureBuilder<List<Artist>>(
        future: NapsterService.getTopArtists(0),
        builder: (BuildContext context, AsyncSnapshot<List<Artist>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              padding: const EdgeInsets.all(15),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final Artist artist = snapshot.data![index];
                return artistCard(artist);
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Align(
            alignment: Alignment.topCenter,
            child: LoadingIndicator(),
          );
        },
      ),
    );
  }

  Widget artistCard(Artist artist) {
    return GestureDetector(
      onTap: () => _showArtistDetail(artist),
      child: Card(
        elevation: 16,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(8.0),
        color: AppTheme.deepBlack,
        child: Column(
          children: [
            Image(
              image: NetworkImage(NapsterService.getArtistImage(artist.id)),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(artist.name),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showArtistDetail(Artist artist) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArtistDetail(artist: artist),
      ),
    );
  }
}
