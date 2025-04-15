// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/modules/detail_anime/screen/detail_anime_screen.dart';
import 'package:anilist/widget/blink.dart';
import 'package:anilist/widget/image/cached_image.dart';
import 'package:anilist/widget/text/text_widget.dart';

class AnimeCard extends StatelessWidget {
  final int animeId;
  final String? imageUrl;
  final double? score;
  final String? title;
  final String? type;
  final int? episode;
  final double? width;
  final double? height;
  final bool imageOnly;

  const AnimeCard({
    super.key,
    required this.animeId,
    required this.imageUrl,
    required this.score,
    required this.title,
    required this.type,
    required this.episode,
    this.width,
    this.height,
    this.imageOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: width ?? 140,
        height: height ?? 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: imageOnly
            ? CachedImage(
                imageUrl: imageUrl,
                width: width ?? 140,
                height: height ?? 190,
                isRounded: true,
              )
            : Stack(
                children: [
                  Stack(
                    children: [
                      CachedImage(
                        imageUrl: imageUrl,
                        width: width ?? 140,
                        height: height ?? 190,
                        isRounded: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3, right: 3),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(300),
                                border: Border.all(color: AppColor.primary)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: Colors.yellow.shade700,
                                  size: 12,
                                ),
                                divideW2,
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: TextWidget(
                                    score != null ? score.toString() : '-',
                                    color: Colors.white,
                                    fontSize: 9,
                                    translate: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildTitle(),
                    ],
                  ),
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        pushTo(context,
                            screen: DetailAnimeScreen(
                                argument:
                                    DetailAnimeArgument(animeId: animeId)),
                            routeName: DetailAnimeScreen.path);
                      },
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ))
                ],
              ),
      ),
    );
  }

  Align _buildTitle() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(11)),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.0)
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  title,
                  color: Colors.white,
                  fontSize: 13,
                  maxLines: 2,
                  ellipsed: true,
                  translate: false,
                ),
                TextWidget(
                  '${type ?? '-'} - ${episode ?? '-'} Episodes',
                  color: Colors.grey,
                  fontSize: 11,
                  maxLines: 2,
                  weight: FontWeight.w400,
                  ellipsed: true,
                  translate: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimeCardLoading extends StatelessWidget {
  const AnimeCardLoading({
    super.key,
    this.height,
    this.width,
    this.radius,
  });

  final double? height;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Blink(
        height: height ?? 190,
        width: width ?? 140,
        radius: radius ?? 12,
      ),
    );
  }
}
