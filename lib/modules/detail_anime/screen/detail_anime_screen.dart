import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/modules/ads/bloc/ads_bloc.dart';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:anilist/modules/detail_anime/bloc/detail_anime_bloc.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/my_list/components/my_list_button.dart';
import 'package:anilist/services/deeplink_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/page/view_handler_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:last_pod_player/last_pod_player.dart';

class DetailAnimeArgument {
  final int animeId;

  DetailAnimeArgument({
    required this.animeId,
  });
}

class DetailAnimeScreen extends StatefulWidget {
  final DetailAnimeArgument argument;
  const DetailAnimeScreen({
    super.key,
    required this.argument,
  });

  static const String path = 'anime/detail';

  @override
  State<DetailAnimeScreen> createState() => _DetailAnimeScreenState();
}

class _DetailAnimeScreenState extends State<DetailAnimeScreen> {
  PodPlayerController? _podPlayerController;
  final _detailAnimeBloc = DetailAnimeBloc();
  final _adsBloc = AdsBloc();

  Anime? _data;
  ViewMode _viewMode = ViewMode.loading;

  @override
  void initState() {
    super.initState();
    _getBloc();
  }

  _getBloc() {
    _detailAnimeBloc.add(GetAnimeByIdEvent(widget.argument.animeId));
  }

  _initPlayer() {
    if (_data?.trailer?.url != null) {
      _podPlayerController = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(
          videoQualityPriority: [360, 480, 720, 1080],
          autoPlay: false,
          isLooping: false,
        ),
        playVideoFrom: PlayVideoFrom.youtube(_data!.trailer!.url!),
      )..initialise();
    }
  }

  @override
  void dispose() {
    if (_podPlayerController != null) {
      _podPlayerController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight.copyWith(
        statusBarColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: AppColor.secondary,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => _detailAnimeBloc,
            ),
            BlocProvider(
              create: (context) => _adsBloc,
            ),
          ],
          child: BlocConsumer<DetailAnimeBloc, DetailAnimeState>(
            bloc: _detailAnimeBloc,
            listener: (context, state) {
              if (state is GetAnimeByIdLoadingState) {
                _viewMode = ViewMode.loading;
              } else if (state is GetAnimeByIdLoadedState) {
                _data = state.data.data;
                _initPlayer();
                _viewMode = ViewMode.loaded;
              } else if (state is GetAnimeByIdFailedState) {
                _viewMode = ViewMode.failed;
              }
            },
            builder: (context, state) {
              return ViewHandlerWidget(
                viewMode: _viewMode,
                child: _data == null ? loading() : _buildView(context),
              );
            },
          ),
        ),
      ),
    );
  }

  Column _buildView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.paddingOf(context).top),
        SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Stack(
              children: [
                _podPlayerController != null
                    ? PodVideoPlayer(controller: _podPlayerController!)
                    : SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.34,
                        child: Center(
                          child: TextWidget(
                            LocaleKeys.trailer_not_available,
                            color: AppColor.black,
                          ),
                        ),
                      ),
                _buildAds(),
              ],
            )),
        //detail anime
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  TextWidget(
                    _data!.title ?? '-',
                    color: AppColor.black,
                    fontSize: 22,
                    weight: FontWeight.bold,
                  ),
                  divide10,

                  //genre
                  if (_data!.genres?.isNotEmpty ?? false)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _data!.genres!
                            .map((genre) => Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.sizeOf(context).width *
                                          0.02),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        right: 4, left: 4, top: 1, bottom: 1),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColor.primary),
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.secondary,
                                    ),
                                    child: Center(
                                        child: TextWidget(
                                      genre.name ?? '-',
                                      fontSize: 13,
                                      color: AppColor.black,
                                    )),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  if (_data!.genres?.isNotEmpty ?? false) divide16,

                  // menu
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        MyListButton(anime: _data!),
                        divideW10,

                        // share
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(300),
                          child: InkWell(
                            onTap: () {
                              DeepLinkService.generateDeeplink(
                                  type: DeepLinkType.anime,
                                  id: widget.argument.animeId.toString());
                            },
                            borderRadius: BorderRadius.circular(300),
                            child: Ink(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColor.secondaryAccent,
                                borderRadius: BorderRadius.circular(300),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    color:
                                        context.read<AppBloc>().state.isDarkMode
                                            ? AppColor.whiteAccent
                                            : AppColor.black,
                                    size: 18,
                                  ),
                                  divideW4,
                                  TextWidget(
                                    LocaleKeys.share,
                                    color:
                                        context.read<AppBloc>().state.isDarkMode
                                            ? AppColor.whiteAccent
                                            : AppColor.black,
                                  ),
                                  divideW4,
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  divide10,
                  //synopsis
                  TextWidget(
                    _data!.synopsis ?? '-',
                    color: AppColor.accent,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAds() {
    return BlocConsumer<AdsBloc, AdsState>(
      bloc: _adsBloc,
      listener: (context, state) {
        if (state is ShowRewardedAdConfirmationState) {
          showConfirmationDialog(
              context: context,
              title: LocaleKeys.watch_ads_to_continue,
              okText: LocaleKeys.watch,
              onTapOk: () {
                Navigator.pop(context);
                _adsBloc.add(ShowRewardedAdEvent(
                    adsType: AdsType.trailer, isCheckAttempt: false));
              });
        } else if (state is ShowRewardedAdLoadedState) {
          _podPlayerController?.play();
        } else if (state is ShowRewardedAdSkippedState) {
          showCustomSnackBar(LocaleKeys.please_watch_the_ad_to_continue,
              isSuccess: false);
        } else if (state is ShowRewardedAdFailedState) {
          showCustomSnackBar(state.message, isSuccess: false);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: state is ShowRewardedAdLoadingState
              ? null
              : () {
                  _adsBloc.add(ShowRewardedAdEvent(
                      adsType: AdsType.trailer, isCheckAttempt: true));
                },
          child: Visibility(
              visible: state is! ShowRewardedAdLoadedState,
              child: Container(
                color: Colors.transparent,
              )),
        );
      },
    );
  }
}
