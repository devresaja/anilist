import 'dart:convert';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/home/components/anime_list.dart';
import 'package:anilist/modules/home/data/home_api.dart';
import 'package:anilist/global/model/anime_list_result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final _homeApi = HomeApi();
  HomeBloc() : super(HomeInitial()) {
    on<GetAnimeListEvent>(_geAnimeList);
    on<GetRandomAnimeEvent>(_geRandomAnime);
  }

  _geRandomAnime(GetRandomAnimeEvent event, Emitter<HomeState> emit) async {
    emit(GetRandomAnimeLoadingState());
    try {
      final response = await _homeApi.getRandomAnime();
      response.fold(
        (left) => emit(GetRandomAnimeFailedState(left)),
        (right) => emit(GetRandomAnimeLoadedState(
            animeResultFromJson(jsonEncode(right.data)))),
      );
    } catch (e) {
      emit(GetAnimeListFailedState(e.toString()));
    }
  }

  _geAnimeList(GetAnimeListEvent event, Emitter<HomeState> emit) async {
    emit(GetAnimeListLoadingState());
    try {
      final response = await _homeApi.getAnimeList(
          params: event.params, animeListType: event.animeListType);
      response.fold(
        (left) => emit(GetAnimeListFailedState(left)),
        (right) {
          final result = animeListResultFromJson(jsonEncode(right.data));
          if (result.data?.isNotEmpty ?? false) {
            emit(GetAnimeListLoadedState(result));
          } else {
            emit(GetAnimeListEmptyState());
          }
        },
      );
    } catch (e) {
      emit(GetAnimeListFailedState(e.toString()));
    }
  }
}
