import 'package:flutter/material.dart';

import 'package:streaming_service/models/artist.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artist_detail/tracks_list.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_image.dart';

class ArtistDetail extends StatefulWidget {
  const ArtistDetail({
    Key? key,
    required this.artist,
  }) : super(key: key);

  final Artist artist;

  @override
  _ArtistDetailState createState() => _ArtistDetailState();
}

class _ArtistDetailState extends State<ArtistDetail> {
  late final Artist artist;

  @override
  void initState() {
    super.initState();
    artist = widget.artist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(artist.name),
              background: Stack(
                children: [
                  Positioned.fill(
                    child: AppImage(
                      url: NapsterService.getArtistImage(artist.id, 'large'),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  if (artist.blurbs.isNotEmpty) ...[
                    Text(artist.blurbs.join("\n\n")),
                    const SizedBox(height: 25),
                  ],
                  TracksList(artistId: artist.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
