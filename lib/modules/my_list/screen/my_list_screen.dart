import 'package:anilist/constant/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/ads/bloc/ads_bloc.dart';
import 'package:anilist/modules/ads/data/admob_api.dart';
import 'package:anilist/modules/home/components/anime_card.dart';
import 'package:anilist/modules/my_list/bloc/my_list_bloc.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/page/view_handler_widget.dart';
import 'package:anilist/widget/text/text_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _myListBloc = context.read<MyListBloc>();
    _getBloc();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 600) {
        if (_viewMode != ViewMode.loadMore && _viewMode != ViewMode.loading) {
          _loadMore();
          _updateViewMode(ViewMode.loadMore);
        }
      }
    });
  }

  late int _totalItems;
  final _animes = <Anime>[];

  void _updateViewMode(ViewMode value) {
    _viewMode = value;
  }

  ViewMode _viewMode = ViewMode.loading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
      minItemsPerRow: 2,
      horizontalGridMargin: 16,
      verticalGridSpacing: 16,
      horizontalGridSpacing: 8,
      rowMainAxisAlignment: MainAxisAlignment.center,
      gridItems: _animes
          .map((anime) => AnimeCard(
                key: ValueKey(anime.malId),
                width: 160,
                height: 200,
                animeId: anime.malId,
                imageUrl: anime.images?.jpg?.imageUrl,
                score: anime.score,
                title: anime.title,
                type: anime.type,
                episode: anime.episodes,
              ))
          .toList(),
      builder: (context, items) {
        return ListView(
          controller: _scrollController,
          addAutomaticKeepAlives: true,
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
            SizedBox(
              height: MediaQuery.paddingOf(context).bottom +
                  kBottomNavigationBarHeight +
                  40,
            ),
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
                title: 'Watch ads to continue',
                okText: 'Watch',
                onTapOk: () {
                  Navigator.pop(context);
                  _adsBloc.add(ShowRewardedAdEvent(
                      adsType: AdsType.mylist, isCheckAttempt: false));
                });
          } else if (state is ShowRewardedAdLoadedState) {
            _pendingCloudAction?.call();
            _pendingCloudAction = null;
          } else if (state is ShowRewardedAdSkippedState) {
            showCustomSnackBar('Please watch the ad to continue',
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
              showCustomSnackBar('Succesfully downloaded');
              _isLoadingCloud = false;
            } else if (state is DownloadMyListFailedState) {
              showCustomSnackBar(state.message, isSuccess: false);
              _isLoadingCloud = false;
            }
            // Upload
            else if (state is UploadMyListLoadingState) {
              _isLoadingCloud = true;
            } else if (state is UploadMyListLoadedState) {
              showCustomSnackBar('Succesfully uploaded');
              _isLoadingCloud = false;
            } else if (state is UploadMyListFailedState) {
              showCustomSnackBar(state.message, isSuccess: false);
              _isLoadingCloud = false;
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    'My List',
                    fontSize: 16,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: _isLoadingCloud
                              ? null
                              : () {
                                  if (!_isLogin()) return;

                                  showConfirmationDialog(
                                    context: context,
                                    title: 'Download from cloud save',
                                    infoText:
                                        '*This action will overwrite your current list.',
                                    onTapOk: () {
                                      Navigator.pop(context);
                                      _pendingCloudAction = () {
                                        _myListBloc.add(DownloadMyListEvent());
                                      };
                                      _adsBloc.add(ShowRewardedAdEvent(
                                          adsType: AdsType.mylist,
                                          isCheckAttempt: true));
                                    },
                                  );
                                },
                          icon: Icon(
                            Icons.cloud_download,
                            color: AppColor.whiteAccent,
                          )),
                      IconButton(
                          onPressed: _isLoadingCloud
                              ? null
                              : () {
                                  if (!_isLogin()) return;

                                  showConfirmationDialog(
                                    context: context,
                                    title: 'Upload to cloud save',
                                    description:
                                        'Uploaded data expires in 14 days. Please upload regularly to avoid losing your data.',
                                    infoText:
                                        '*This action will overwrite your existing cloud save.',
                                    onTapOk: () {
                                      Navigator.pop(context);
                                      _pendingCloudAction = () {
                                        _myListBloc.add(UploadMyListEvent());
                                      };
                                      _adsBloc.add(ShowRewardedAdEvent(
                                          adsType: AdsType.mylist,
                                          isCheckAttempt: true));
                                    },
                                  );
                                },
                          icon: Icon(
                            Icons.cloud_upload,
                            color: AppColor.whiteAccent,
                          )),
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

  bool _isLogin() {
    if (context.read<AppBloc>().state.user == null) {
      showAccessDeniedDialog(context);
      return false;
    }
    return true;
  }
}
