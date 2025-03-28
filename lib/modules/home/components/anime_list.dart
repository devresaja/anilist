import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/home/bloc/home_bloc.dart';
import 'package:anilist/modules/home/components/anime_card.dart';
import 'package:anilist/widget/page/view_handler_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AnimeListType {
  top,
  ongoing,
}

class AnimeListWidget extends StatefulWidget {
  final AnimeListType animeListType;
  const AnimeListWidget({super.key, required this.animeListType});

  @override
  State<AnimeListWidget> createState() => _AnimeListWidgetState();
}

class _AnimeListWidgetState extends State<AnimeListWidget> {
  final _homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    _getBloc();
  }

  _getBloc() {
    _homeBloc.add(GetAnimeListEvent(
        params: const {"page": 1, "limit": 10},
        animeListType: widget.animeListType));
  }

  final _animes = <Anime>[];

  ViewMode _viewMode = ViewMode.loading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetAnimeListLoadingState) {
            _viewMode = ViewMode.loading;
          } else if (state is GetAnimeListLoadedState) {
            _animes.addAll(state.result.data!);
            _viewMode = ViewMode.loaded;
          } else if (state is GetAnimeListEmptyState) {
            _viewMode = ViewMode.empty;
          } else if (state is GetAnimeListFailedState) {
            _viewMode = ViewMode.failed;
          }
        },
        builder: (context, state) {
          return ViewHandlerWidget(
            viewMode: _viewMode,
            customLoading: _buildLoading(),
            child: _buildView(),
          );
        },
      ),
    );
  }

  SingleChildScrollView _buildView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_animes.length, (index) {
          final anime = _animes[index];
          return AnimeCard(
            animeId: anime.malId,
            imageUrl: anime.images?.jpg?.imageUrl,
            score: anime.score,
            title: anime.title,
            type: anime.type,
            episode: anime.episodes,
          );
        }),
      ),
    );
  }

  SingleChildScrollView _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(6, (index) => const AnimeCardLoading()),
      ),
    );
  }
}
