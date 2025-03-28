// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:anilist/core/routes/route.dart';
import 'package:anilist/modules/detail_anime/screen/detail_anime_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anilist/constant/app_color.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/home/bloc/home_bloc.dart';
import 'package:anilist/modules/home/components/anime_card.dart';
import 'package:anilist/widget/blink.dart';
import 'package:anilist/widget/card/small_rounded_card.dart';
import 'package:anilist/widget/image/cached_image.dart';
import 'package:anilist/widget/page/view_handler_widget.dart';
import 'package:anilist/widget/text/text_widget.dart';

class HomeRandom extends StatefulWidget {
  const HomeRandom({super.key});

  @override
  State<HomeRandom> createState() => _HomeRandomState();
}

class _HomeRandomState extends State<HomeRandom> {
  final _homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    _homeBloc.add(GetRandomAnimeEvent());
  }

  ViewMode _viewMode = ViewMode.loading;

  Anime? _data;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetRandomAnimeLoadingState) {
            _viewMode = ViewMode.loading;
          } else if (state is GetRandomAnimeLoadedState) {
            _data = state.result.data;
            _viewMode = ViewMode.loaded;
          } else if (state is GetRandomAnimeFailedState) {
            _viewMode = ViewMode.failed;
          }
        },
        builder: (context, state) {
          return ViewHandlerWidget(
            viewMode: _viewMode,
            customLoading: _buildLoading(),
            customFailed: Container(),
            child: _data == null ? _buildLoading() : _buildView(),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                  painter: BorderPainter(isLoading: true),
                  child: ClipPath(
                    clipper: HorizontalCutClipper(),
                    child: Blink(
                      height: 100,
                      width: double.infinity,
                      radius: 0,
                    ),
                  )),
            ),
            Positioned(
                right: 12,
                child: AnimeCardLoading(
                  width: 70,
                  height: 110,
                ))
          ],
        ),
      ),
    );
  }

  Container _buildView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 120,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomPaint(
                painter: BorderPainter(isLoading: false),
                child: ClipPath(
                  clipper: HorizontalCutClipper(),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Opacity(
                                opacity: 0.3,
                                child: CachedImage(
                                    width: double.infinity,
                                    imageUrl: _data!.images?.jpg?.imageUrl)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10, top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      _data!.title ?? '-',
                                      maxLines: 2,
                                      ellipsed: true,
                                      color: Colors.white,
                                    ),
                                    const Spacer(),
                                    SmallRoundedCard(
                                      onTap: () {
                                        pushTo(context,
                                            screen: DetailAnimeScreen(
                                                argument: DetailAnimeArgument(
                                                    animeId: _data!.malId)));
                                      },
                                      text: 'See detail',
                                      textColor: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 90)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 28,
            child: AnimeCard(
              animeId: _data!.malId,
              imageOnly: true,
              width: 70,
              height: 110,
              imageUrl: _data!.images?.jpg?.imageUrl,
              score: _data!.score,
              title: _data!.title,
              type: _data!.type,
              episode: _data!.episodes,
            ),
          )
        ],
      ),
    );
  }
}

class HorizontalCutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 10;

    Path path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..lineTo(size.width, radius)
      ..lineTo(size.width, size.height)
      ..lineTo(radius, size.height)
      ..lineTo(0, size.height - radius)
      ..lineTo(0, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BorderPainter extends CustomPainter {
  final bool isLoading;
  BorderPainter({
    required this.isLoading,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 10;
    Paint paint = Paint()
      ..color =
          isLoading ? Colors.grey.shade400 : AppColor.primary // Warna border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Tebal border

    Path path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..lineTo(size.width, radius)
      ..lineTo(size.width, size.height)
      ..lineTo(radius, size.height)
      ..lineTo(0, size.height - radius)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
