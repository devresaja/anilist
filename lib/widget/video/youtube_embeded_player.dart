// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui_web';
import 'package:flutter/material.dart';

class YoutubeEmbededPlayer extends StatelessWidget {
  final String videoId;
  final double aspectRatio;

  YoutubeEmbededPlayer({
    required this.videoId,
    this.aspectRatio = 16 / 9,
    super.key,
  }) {
    platformViewRegistry.registerViewFactory(
      'youtube-iframe-$videoId',
      (int viewId) {
        final iframe = IFrameElement()
          ..src = 'https://www.youtube.com/embed/$videoId';

        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: HtmlElementView(
        viewType: 'youtube-iframe-$videoId',
      ),
    );
  }
}
