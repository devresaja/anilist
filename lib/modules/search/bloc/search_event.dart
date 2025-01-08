part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchAnimeEvent extends SearchEvent {
  final Map<String, dynamic> params;

  const SearchAnimeEvent(this.params);
}
