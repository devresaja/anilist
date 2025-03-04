import 'dart:convert';

import 'package:anilist/modules/detail_anime/data/detail_anime_api.dart';
import 'package:anilist/global/model/anime.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'detail_anime_event.dart';
part 'detail_anime_state.dart';

class DetailAnimeBloc extends Bloc<DetailAnimeEvent, DetailAnimeState> {
  final _api = DetailAnimeApi();

  DetailAnimeBloc() : super(DetailAnimeInitial()) {
    on<GetAnimeByIdEvent>(_getAnimeById);
  }

  _getAnimeById(GetAnimeByIdEvent event, Emitter<DetailAnimeState> emit) async {
    emit(GetAnimeByIdLoadingState());
    try {
      final response = await _api.getAnimeById(event.animeId);
      response.fold(
        (left) => emit(GetAnimeByIdFailedState(left)),
        (right) => emit(GetAnimeByIdLoadedState(
            animeResultFromJson(jsonEncode(right.data)))),
      );
    } catch (e) {
      emit(GetAnimeByIdFailedState(e.toString()));
    }
  }
}
