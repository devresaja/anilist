import 'dart:convert';

import 'package:anilist/global/model/anime_list_result.dart';
import 'package:anilist/modules/search/data/search_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _api = SearchApi();
  SearchBloc() : super(SearchInitial()) {
    on<SearchAnimeEvent>(_searchAnime);
  }

  _searchAnime(SearchAnimeEvent event, Emitter<SearchState> emit) async {
    emit(SearchAnimeLoadingState());
    try {
      final response = await _api.searchAnime(params: event.params);
      response.fold(
        (left) => emit(SearchAnimeFailedState(left)),
        (right) {
          final result = animeListResultFromJson(jsonEncode(right.data));
          if (result.data?.isNotEmpty ?? false) {
            emit(SearchAnimeLoadedState(result));
            if (result.pagination?.hasNextPage == false) {
              emit(SearchAnimeMaximumState());
            }
          } else {
            emit(SearchAnimeEmptyState());
          }
        },
      );
    } catch (e) {
      emit(SearchAnimeFailedState(e.toString()));
    }
  }
}
