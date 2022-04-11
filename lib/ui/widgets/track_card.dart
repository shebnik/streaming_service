import 'package:flutter/material.dart';

import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_image.dart';
import 'package:streaming_service/ui/widgets/track_player/track_player.dart';

class TrackCard extends StatelessWidget {
  const TrackCard({
    Key? key,
    required this.track,
    this.showArtistName = false,
  }) : super(key: key);

  final Track track;
  final bool showArtistName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => TrackPlayer(track: track),
      ),
      child: Card(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        color: AppTheme.blackMatte,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              SizedBox(
                width: 65,
                child: AppImage(
                  url: NapsterService.getTrackImage(track.albumId),
                  key: UniqueKey(),
                ),
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
                        showArtistName
                            ? track.artistName + " - " + track.albumName
                            : track.albumName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.grayMiddle,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              showArtistName
                  ? const SizedBox.shrink()
                  : const Padding(
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
}
