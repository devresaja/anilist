import 'package:anilist/constant/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/global/widget/speech_to_text_button.dart';
import 'package:anilist/modules/ads/widget/admob_banner_widget.dart';
import 'package:anilist/modules/home/components/anime_card.dart';
import 'package:anilist/modules/search/bloc/search_bloc.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/page/view_handler_widget.dart';
import 'package:anilist/widget/text/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class SearchScreen extends StatefulWidget {
  final String search;
  const SearchScreen({super.key, required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  final _searchBloc = SearchBloc();
  int _currentPage = 1;

  _getBloc() {
    Map<String, dynamic> params = {};
    params['page'] = _currentPage;
    params['limit'] = 20;
    if (_searchController.text.isNotEmpty) {
      params['q'] = _searchController.text;
    }
    params['sfw'] = true;
    _searchBloc.add(SearchAnimeEvent(params));
  }

  _loadMore() {
    _currentPage++;
    _getBloc();
  }

  _refreshBloc() {
    _animes.clear();
    _currentPage = 1;
    _getBloc();
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.search;
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

  ViewMode _viewMode = ViewMode.loading;

  void _updateViewMode(ViewMode value) {
    setState(() {
      _viewMode = value;
    });
  }

  final _animes = <Anime>[];

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: BlocProvider(
                create: (context) => _searchBloc,
                child: BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state) {
                    if (state is SearchAnimeLoadingState) {
                      if (_animes.isEmpty) {
                        _updateViewMode(ViewMode.loading);
                      } else {
                        _updateViewMode(ViewMode.loadMore);
                      }
                    } else if (state is SearchAnimeLoadedState) {
                      _animes.addAll(state.data.data!);
                      _updateViewMode(ViewMode.loaded);
                    } else if (state is SearchAnimeEmptyState) {
                      if (_animes.isEmpty) {
                        _updateViewMode(ViewMode.empty);
                      }
                    } else if (state is SearchAnimeMaximumState) {
                      _updateViewMode(ViewMode.loadMax);
                    } else if (state is SearchAnimeFailedState) {
                      if (_animes.isEmpty) {
                        _updateViewMode(ViewMode.failed);
                      }
                    }
                  },
                  builder: (context, state) {
                    return ViewHandlerWidget(
                      viewMode: _viewMode,
                      onTapError: _getBloc,
                      child: _buildView(),
                    );
                  },
                ),
              ),
            ),
            AdMobBannerWidget()
            // UnityBannerAdWidget(placementId: 'Banner_Android')
          ],
        ),
      ),
    );
  }

  Widget _buildView() {
    return Column(
      children: [
        Expanded(
          child: ResponsiveGridListBuilder(
            verticalGridMargin: 16,
            minItemWidth: 160,
            minItemsPerRow: 2,
            horizontalGridMargin: 16,
            verticalGridSpacing: 16,
            horizontalGridSpacing: 8,
            rowMainAxisAlignment: MainAxisAlignment.center,
            gridItems: _animes
                .map((anime) => AnimeCard(
                      width: 160,
                      height: 200,
                      animeId: anime.malId!,
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
                  ...items,
                  if (_viewMode == ViewMode.loadMore) loading()
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Row _buildHeader() {
    return Row(
      children: [
        divideW16,
        Flexible(
          child: CustomSearchBar(
            height: 46,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            withPaddingHorizontal: false,
            hintText: 'Search title',
            controller: _searchController,
            onSubmitted: (value) {
              _refreshBloc();
            },
          ),
        ),
        divideW6,
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SpeechToTextButton(
              onResult: (value) {
                _searchController.text = value;
                _refreshBloc();
              },
            ))
      ],
    );
  }
}
