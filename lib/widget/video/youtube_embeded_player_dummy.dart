import 'package:flutter/material.dart';

class YoutubeEmbededPlayer extends StatelessWidget {
  final String videoId;
  final double aspectRatio;

  const YoutubeEmbededPlayer({
    required this.videoId,
    this.aspectRatio = 16 / 9,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: SizedBox.shrink(),
    );
  }
}
