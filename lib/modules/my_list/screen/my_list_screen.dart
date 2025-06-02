import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/extension/view_extension.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/ads/bloc/ads_bloc.dart';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:anilist/modules/home/components/anime_card.dart';
import 'package:anilist/modules/my_list/bloc/my_list_bloc.dart';
import 'package:anilist/services/deeplink_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/page/view_handler_widget.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  late final MyListBloc _myListBloc;

  final _scrollController = ScrollController();
  int _currentPage = 1;

  _getBloc() {
    _myListBloc.add(GetMyListEvent(page: _currentPage, limit: 10));
  }

  _refreshBloc() {
    setState(() {
      _animes.clear();
    });
    _currentPage = 1;
    _getBloc();
  }

  _loadMore() {
    _currentPage++;
    _getBloc();
  }

  final _adsBloc = AdsBloc();
  bool _isLoadingCloud = false;
  VoidCallback? _pendingCloudAction;

  _initBloc() {
    if (kIsWeb) {
      _updateViewMode(ViewMode.maintenance);
      return;
    }

    _myListBloc = context.read<MyListBloc>();
    _getBloc();
    _scrollController.addInfiniteScrollListener(
      viewMode: () => _viewMode,
      onLoadMore: () {
        _loadMore();
        _updateViewMode(ViewMode.loadMore);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initBloc();
  }

  late int _totalItems;
  final _animes = <Anime>[];

  ViewMode _viewMode = ViewMode.loading;

  void _updateViewMode(ViewMode value) {
    _viewMode = value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: AppColor.secondary,
        body: Column(
          children: [
            _buildHeader(context),
            BlocConsumer<MyListBloc, MyListState>(
              listener: (context, state) {
                // Get
                if (state is GetMyListLoadingState) {
                  if (_animes.isEmpty) {
                    _updateViewMode(ViewMode.loading);
                  } else {
                    _updateViewMode(ViewMode.loadMore);
                  }
                } else if (state is GetMyListLoadedState) {
                  _totalItems = state.totalItems;
                  _animes.addAll(state.data);
                  _updateViewMode(ViewMode.loaded);
                } else if (state is GetMyListEmptyState) {
                  if (_animes.isEmpty) {
                    _updateViewMode(ViewMode.empty);
                  }
                } else if (state is GetMyListMaximumState) {
                  _updateViewMode(ViewMode.loadMax);
                } else if (state is GetMyListFailedState) {
                  if (_animes.isEmpty) {
                    _updateViewMode(ViewMode.failed);
                  }
                }
                // Add
                else if (state is AddMyListLoadedState) {
                  _animes.insert(0, state.anime);
                  _totalItems++;
                }
                // Delete
                else if (state is DeleteMyListLoadedState) {
                  _animes
                      .removeWhere((element) => element.malId == state.malId);
                  _totalItems--;
                  if (_animes.isEmpty) {
                    _updateViewMode(ViewMode.empty);
                  }
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: ViewHandlerWidget(
                    viewMode: _viewMode,
                    onTapError: _getBloc,
                    child: _buildView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildView() {
    return ResponsiveGridListBuilder(
      minItemWidth: 160,
      horizontalGridMargin: 16,
      minItemsPerRow: 2,
      verticalGridSpacing: 16,
      horizontalGridSpacing: 8,
      rowMainAxisAlignment: MainAxisAlignment.center,
      gridItems: _animes
          .map((anime) => AspectRatio(
                aspectRatio: 6 / 9,
                child: AnimeCard(
                  key: ValueKey(anime.malId),
                  animeId: anime.malId,
                  imageUrl: anime.images?.jpg?.imageUrl,
                  score: anime.score,
                  title: anime.title,
                  type: anime.type,
                  episode: anime.episodes,
                  isDynamicSize: true,
                ),
              ))
          .toList(),
      builder: (context, items) {
        return ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextWidget('Total Anime $_totalItems'),
            ),
            ...items,
            if (_viewMode == ViewMode.loadMore) ...[
              divide10,
              loading(),
            ],
            if (!context.isWideScreen)
              SizedBox(
                height: MediaQuery.paddingOf(context).bottom +
                    kBottomNavigationBarHeight,
              )
            else
              divide16,
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocProvider(
      create: (context) => _adsBloc,
      child: BlocListener<AdsBloc, AdsState>(
        listener: (context, state) {
          if (state is ShowRewardedAdConfirmationState) {
            showConfirmationDialog(
                context: context,
                title: LocaleKeys.watch_ads_to_continue,
                okText: LocaleKeys.watch,
                onTapOk: () {
                  Navigator.pop(context);
                  _showRewardedAd(isCheckAttempt: false);
                });
          } else if (state is ShowRewardedAdLoadedState) {
            _pendingCloudAction?.call();
            _pendingCloudAction = null;
          } else if (state is ShowRewardedAdSkippedState) {
            showCustomSnackBar(LocaleKeys.please_watch_the_ad_to_continue,
                isSuccess: false);
          } else if (state is ShowRewardedAdFailedState) {
            showCustomSnackBar(state.message, isSuccess: false);
          }
        },
        child: BlocConsumer<MyListBloc, MyListState>(
          listener: (context, state) {
            // Download
            if (state is DownloadMyListLoadingState) {
              _isLoadingCloud = true;
            } else if (state is DownloadMyListLoadedState) {
              _refreshBloc();
              showCustomSnackBar(LocaleKeys.successfully_downloaded);
              _isLoadingCloud = false;
            } else if (state is DownloadMyListFailedState) {
              showCustomSnackBar(state.message, isSuccess: false);
              _isLoadingCloud = false;
            }
            // Upload
            else if (state is UploadMyListLoadingState) {
              _isLoadingCloud = true;
            } else if (state is UploadMyListLoadedState) {
              showCustomSnackBar(LocaleKeys.successfully_uploaded);
              _isLoadingCloud = false;
            } else if (state is UploadMyListFailedState) {
              showCustomSnackBar(state.message, isSuccess: false);
              _isLoadingCloud = false;
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(left: 16, top: kIsWeb ? 16 : 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    LocaleKeys.mylist,
                    fontSize: 16,
                  ),
                  if (!kIsWeb)
                    Row(
                      children: [
                        _buildCloudIconButton(
                          icon: Icons.cloud_download,
                          onTap: () => _downloadFromCloud(context),
                          isDisabled: _isLoadingCloud,
                        ),
                        _buildCloudIconButton(
                          icon: Icons.cloud_upload,
                          onTap: () => _uploadToCloud(context),
                          isDisabled: _isLoadingCloud,
                        ),
                        _buildCloudIconButton(
                          icon: Icons.share_outlined,
                          onTap: () => _shareMyList(context),
                          isDisabled: _isLoadingCloud,
                        ),
                      ],
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCloudIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return IconButton(
      onPressed: isDisabled
          ? null
          : () {
              if (!_isLogin()) return;
              onTap();
            },
      icon: Icon(
        icon,
        color: AppColor.whiteAccent,
      ),
    );
  }

  void _downloadFromCloud(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: LocaleKeys.download_from_cloud_save,
      infoText: LocaleKeys.download_warning,
      onTapOk: () {
        Navigator.pop(context);

        _pendingCloudAction = () {
          _myListBloc.add(DownloadMyListEvent());
        };

        _showRewardedAd(isCheckAttempt: true);
      },
    );
  }

  void _uploadToCloud(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: LocaleKeys.upload_to_cloud_save,
      description: LocaleKeys.upload_expiry_notice,
      infoText: LocaleKeys.upload_overwrite_warning,
      onTapOk: () {
        Navigator.pop(context);

        _pendingCloudAction = () {
          _myListBloc.add(UploadMyListEvent());
        };

        _showRewardedAd(isCheckAttempt: true);
      },
    );
  }

  void _shareMyList(BuildContext context) {
    DeepLinkService.generateDeeplink(
      type: DeepLinkType.mylist,
      id: context.read<AppBloc>().state.user!.userId!,
    );
  }

  void _showRewardedAd({required bool isCheckAttempt}) {
    _adsBloc.add(ShowRewardedAdEvent(
      adsType: AdsType.mylist,
      isCheckAttempt: isCheckAttempt,
    ));
  }

  bool _isLogin() {
    if (context.read<AppBloc>().state.user == null) {
      showAccessDeniedDialog(context);
      return false;
    }
    return true;
  }
}
