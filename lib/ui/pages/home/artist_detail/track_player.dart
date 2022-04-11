// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:streaming_service/models/track.dart';
import 'package:streaming_service/services/napster_service.dart';
import 'package:streaming_service/ui/pages/home/artist_detail/audio_slider.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';
import 'package:streaming_service/ui/widgets/app_button.dart';
import 'package:streaming_service/ui/widgets/app_image.dart';

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
        child: Column(
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
                        child: AppButton(
                          height: 30,
                          text: 'Add to library',
                          onPressed: _playTrack,
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
        ),
      ),
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

  void _addToLibrary() {
    // TODO: Add to library
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
