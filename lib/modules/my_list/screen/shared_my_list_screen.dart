import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/modules/home/components/anime_card.dart';
import 'package:anilist/modules/my_list/bloc/my_list_bloc.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/image/cached_image.dart';
import 'package:anilist/widget/page/view_handler_widget.dart';
import 'package:anilist/widget/text/text_widget.dart';
import 'package:anilist/widget/wrapper/invisible_expanded_header.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class SharedMyListArgument {
  final String id;

  SharedMyListArgument(this.id);
}

class SharedMyListScreen extends StatefulWidget {
  final SharedMyListArgument argument;
  static const String path = '/mylist/shared';
  const SharedMyListScreen({
    super.key,
    required this.argument,
  });

  @override
  State<SharedMyListScreen> createState() => _SharedMyListScreenState();
}

class _SharedMyListScreenState extends State<SharedMyListScreen> {
  late final MyListBloc _myListBloc;

  _getBloc() {
    _myListBloc.add(GetSharedMyListEvent(widget.argument.id));
  }

  @override
  void initState() {
    super.initState();
    _myListBloc = context.read<MyListBloc>();
    _getBloc();
  }

  late int _totalItems;
  final _animes = <Anime>[];
  late UserData _userData;

  ViewMode _viewMode = ViewMode.loading;

  void _updateViewMode(ViewMode value) {
    _viewMode = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: BlocConsumer<MyListBloc, MyListState>(
        listener: (context, state) {
          if (state is GetSharedMyListLoadingState) {
            if (_animes.isEmpty) {
              _updateViewMode(ViewMode.loading);
            } else {
              _updateViewMode(ViewMode.loadMore);
            }
          } else if (state is GetSharedMyListLoadedState) {
            _totalItems = state.data.data.length;
            _animes.addAll(state.data.data);
            _userData = state.data.userData;
            _updateViewMode(ViewMode.loaded);
          } else if (state is GetSharedMyListEmptyState) {
            if (_animes.isEmpty) {
              _updateViewMode(ViewMode.empty);
            }
          } else if (state is GetSharedMyListFailedState) {
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
                width: 160,
                height: 200,
                animeId: anime.malId,
                imageUrl: anime.images?.webp?.imageUrl,
                score: anime.score,
                title: anime.title,
                type: anime.type,
                episode: anime.episodes,
              ))
          .toList(),
      builder: (context, items) {
        return ExtendedNestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                      surfaceTintColor: Colors.transparent,
                      systemOverlayStyle:
                          (context.read<AppBloc>().state.isDarkMode
                                  ? systemUiOverlayStyleLight
                                  : systemUiOverlayStyleDark)
                              .copyWith(statusBarColor: Colors.transparent),
                      backgroundColor: AppColor.secondary,
                      pinned: true,
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: AppColor.black,
                          )),
                      snap: false,
                      floating: false,
                      expandedHeight: calculateAspectRationHeight(context,
                          width: MediaQuery.sizeOf(context).width,
                          aspectRatio: 1 / 0.55),
                      flexibleSpace: FlexibleSpaceBar(
                        title: InvisibleExpandedHeader(
                          child: TextWidget(
                            _userData.name,
                            maxLines: 1,
                            color: AppColor.black,
                            ellipsed: true,
                          ),
                        ),
                        background: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: MediaQuery.paddingOf(context).top),
                            divide32,
                            CachedImage(
                              imageUrl: _userData.avatar,
                              isCircle: true,
                              width: 80,
                              height: 80,
                            ),
                            divide8,
                            TextWidget(
                              _userData.name,
                              color: AppColor.black,
                              maxLines: 2,
                              ellipsed: true,
                            ),
                            TextWidget(
                              _userData.email,
                              color: AppColor.accent,
                              maxLines: 1,
                              ellipsed: true,
                            ),
                          ],
                        ),
                      )),
                ],
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextWidget('Total Anime $_totalItems'),
                ),
                ...items,
                divide16
              ],
            ));
      },
    );
  }
}
