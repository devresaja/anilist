part of 'detail_anime_bloc.dart';

sealed class DetailAnimeState extends Equatable {
  const DetailAnimeState();

  @override
  List<Object> get props => [];
}

final class DetailAnimeInitial extends DetailAnimeState {}

final class GetAnimeByIdLoadingState extends DetailAnimeState {}

final class GetAnimeByIdLoadedState extends DetailAnimeState {
  final AnimeResult data;

  const GetAnimeByIdLoadedState(this.data);
}

final class GetAnimeByIdFailedState extends DetailAnimeState {
  final String message;

  const GetAnimeByIdFailedState(this.message);
}
