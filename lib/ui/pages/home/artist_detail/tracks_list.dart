// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artist_detail/track_player.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_button.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';

class TracksList extends StatefulWidget {
  const TracksList({
    Key? key,
    required this.artistId,
  }) : super(key: key);

  final String artistId;

  @override
  _TracksListState createState() => _TracksListState();
}

class _TracksListState extends State<TracksList> {
  late String artistId;

  ValueNotifier<bool> isLoading = ValueNotifier(true);
  int currentOffset = 0;
  List<Track> tracks = [];

  @override
  void initState() {
    super.initState();
    artistId = widget.artistId;
    _loadTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: tracks.length,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 15),
          itemBuilder: (BuildContext context, int index) {
            final Track track = tracks[index];
            return trackCard(track);
          },
        ),
        const SizedBox(height: 25),
        ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (_, _isLoading, __) {
            return _isLoading
                ? const LoadingIndicator()
                : AppButton(
                    height: 50,
                    width: 200,
                    text: 'Load more',
                    onPressed: _loadMore,
                  );
          },
        ),
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

  Future<void> _loadMore() async {
    isLoading.value = true;
    currentOffset += 5;
    await _loadTracks();
  }

  Future<void> _loadTracks() async {
    tracks.addAll(
      await NapsterService.getArtistTopTracks(artistId, currentOffset),
    );
    isLoading = ValueNotifier(false);
    setState(() {});
  }
}
