part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class GetAnimeListLoadingState extends HomeState {}

final class GetAnimeListEmptyState extends HomeState {}

final class GetAnimeListLoadedState extends HomeState {
  final AnimeListResult result;

  const GetAnimeListLoadedState(this.result);
}

final class GetAnimeListFailedState extends HomeState {
  final String message;

  const GetAnimeListFailedState(this.message);
}

final class GetRandomAnimeLoadingState extends HomeState {}

final class GetRandomAnimeLoadedState extends HomeState {
  final AnimeResult result;

  const GetRandomAnimeLoadedState(this.result);
}

final class GetRandomAnimeFailedState extends HomeState {
  final String message;

  const GetRandomAnimeFailedState(this.message);
}
