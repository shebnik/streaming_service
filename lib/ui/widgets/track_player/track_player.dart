import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/firestore_service.dart';
import 'package:streaming_service/services/hive_service.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_button.dart';
import 'package:streaming_service/ui/widgets/app_image.dart';
import 'package:streaming_service/ui/widgets/loading_indicator.dart';
import 'package:streaming_service/ui/widgets/track_player/audio_slider.dart';

class TrackPlayer extends StatefulWidget {
  const TrackPlayer({
    Key? key,
    required this.track,
  }) : super(key: key);

  final Track track;

  @override
  State<TrackPlayer> createState() => _TrackPlayerState();
}

class _TrackPlayerState extends State<TrackPlayer> {
  Box<Track>? favouritesBox;
  ValueNotifier<String> buttonName = ValueNotifier('');

  late final Track track;

  AudioPlayer player = AudioPlayer();

  final ValueNotifier<bool> _isPlaying = ValueNotifier(true);
  final ValueNotifier<Duration> duration =
      ValueNotifier(const Duration(seconds: 29));
  final ValueNotifier<Duration> position = ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    track = widget.track;
    HiveService.getFavouritesBox().then((value) {
      favouritesBox = value;
      initialize();
      setState(() => {});
    });
  }

  void initialize() {
    buttonName.value = favouritesBox!.containsKey(track.id)
        ? 'Remove from favourites'
        : 'Add to favourites';
    _playTrack();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: const BoxDecoration(color: AppTheme.grayDeep),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: favouritesBox == null
            ? const Center(
                child: LoadingIndicator(),
              )
            : _buildTrackPlayer(),
      ),
    );
  }

  Widget _buildTrackPlayer() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: AppImage(
                  url: NapsterService.getTrackImage(track.albumId),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(height: 5),
                  Text(
                    track.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    track.artistName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.grayMiddle,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ValueListenableBuilder<String>(
                      valueListenable: buttonName,
                      builder: (context, value, child) {
                        return AppButton(
                          height: 30,
                          text: value,
                          onPressed: _addToFavourites,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _trackControls(),
      ],
    );
  }

  Widget _trackControls() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _handlePlayPause,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isPlaying,
            builder: (context, isPlaying, child) {
              return Icon(
                isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                color: AppTheme.primaryColor,
                size: 50,
              );
            },
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<Duration>(
            valueListenable: duration,
            builder: (context, _duration, child) {
              return ValueListenableBuilder<Duration>(
                valueListenable: position,
                builder: (context, _position, child) {
                  return AudioSlider(
                    controller: player,
                    duration: _duration,
                    position: _position,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _addToFavourites() async {
    if (favouritesBox!.containsKey(track.id)) {
      buttonName.value = 'Add to favourites';
      await FirestoreService.removeFromFavourites(favouritesBox!.get(track.id)!);
      await favouritesBox!.delete(track.id);
    } else {
      Track favouriteTrack = track.copyWith(
        timeWhenAddedToFavourites: DateTime.now(),
      );
      buttonName.value = 'Remove from favourites';
      await favouritesBox!.put(track.id, favouriteTrack);
      await FirestoreService.addToFavourites(favouriteTrack);
    }
  }

  Future<void> _playTrack() async {
    int result = await player.play(track.previewURL);
    if (result == 1) {
      player.onDurationChanged.listen((Duration d) => duration.value = d);
      player.onAudioPositionChanged.listen((Duration p) => position.value = p);
      player.onPlayerStateChanged.listen((PlayerState s) {
        if (s == PlayerState.COMPLETED) {
          _isPlaying.value = false;
        }
      });
    }
  }

  void _handlePlayPause() {
    if (_isPlaying.value) {
      player.pause();
    } else {
      player.resume();
    }
    _isPlaying.value = !_isPlaying.value;
  }
}
