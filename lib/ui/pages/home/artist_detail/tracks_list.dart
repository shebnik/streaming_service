import 'package:flutter/material.dart';

import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/widgets/app_button.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';
import 'package:streaming_service/ui/widgets/track_card.dart';

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
          itemBuilder: (BuildContext context, int index) => TrackCard(
            track: tracks[index],
          ),
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
