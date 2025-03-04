part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class GetAnimeListEvent extends HomeEvent {
  final Map<String, dynamic>? params;
  final AnimeListType animeListType;

  const GetAnimeListEvent({this.params, required this.animeListType});
}

final class GetRandomAnimeEvent extends HomeEvent {}
