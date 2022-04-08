// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:streaming_service/models/artist.dart';
import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artists/track_player.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';

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
  var currentOffset = 0;

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
                    child: Image.network(
                      NapsterService.getArtistImage(artist.id, 'large'),
                      fit: BoxFit.fill,
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
              child: contentBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentBody() {
    return Column(
      children: [
        Text(artist.blurbs.join("\n\n")),
        const SizedBox(height: 25),
        FutureBuilder<List<Track>>(
          future: NapsterService.getArtistTopTracks(artist.id, currentOffset),
          builder: (BuildContext context, AsyncSnapshot<List<Track>> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 15),
                itemBuilder: (BuildContext context, int index) {
                  final Track track = snapshot.data![index];
                  return trackCard(track);
                },
              );
            } else if (snapshot.hasError) {
              return const LoadingIndicator();
            }
            return const LoadingIndicator();
          },
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget trackCard(Track track) {
    return GestureDetector(
      onTap: () => _playTrack(track),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: AppTheme.blackMatte,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              Image.network(
                NapsterService.getTrackImage(track.albumId),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        track.albumName,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.grayMiddle,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 19),
                child: Icon(
                  Icons.play_circle_outline,
                  size: 28,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _playTrack(Track track) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => TrackPlayer(track: track),
    );
  }
}
