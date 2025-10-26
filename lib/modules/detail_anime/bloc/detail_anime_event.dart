part of 'detail_anime_bloc.dart';

sealed class DetailAnimeEvent extends Equatable {
  const DetailAnimeEvent();

  @override
  List<Object> get props => [];
}

final class GetAnimeByIdEvent extends DetailAnimeEvent {
  final String animeId;

  const GetAnimeByIdEvent(this.animeId);
}
