part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchAnimeLoadingState extends SearchState {}

final class SearchAnimeLoadedState extends SearchState {
  final AnimeListResult data;

  const SearchAnimeLoadedState(this.data);
}

final class SearchAnimeMaximumState extends SearchState {}

final class SearchAnimeEmptyState extends SearchState {}

final class SearchAnimeFailedState extends SearchState {
  final String message;

  const SearchAnimeFailedState(this.message);
}
