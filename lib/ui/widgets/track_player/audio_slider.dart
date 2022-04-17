import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:streaming_service/ui/theme/app_theme.dart';

class AudioSlider extends StatelessWidget {
  const AudioSlider({
    Key? key,
    required this.controller,
    required this.duration,
    required this.position,
  }) : super(key: key);

  final AudioPlayer controller;
  final Duration duration;
  final Duration position;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 32,
          child: Slider.adaptive(
            value: position.inMilliseconds / duration.inMilliseconds,
            activeColor: AppTheme.primaryColor,
            onChanged: (double value) =>
                controller.seek(duration * value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                position.toString().split('.').first,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                duration.toString().split('.').first,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
