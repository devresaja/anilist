part of 'my_list_bloc.dart';

sealed class MyListState extends Equatable {
  const MyListState();

  @override
  List<Object> get props => [];
}

final class MyListInitial extends MyListState {}

final class GetMyListLoadingState extends MyListState {}

final class GetMyListLoadedState extends MyListState {
  final int totalItems;
  final List<Anime> data;

  const GetMyListLoadedState({
    required this.totalItems,
    required this.data,
  });
}

final class GetMyListEmptyState extends MyListState {}

final class GetMyListMaximumState extends MyListState {}

final class GetMyListFailedState extends MyListState {
  final String message;

  const GetMyListFailedState(this.message);
}

final class CheckMyListLoadingState extends MyListState {}

final class CheckMyListLoadedState extends MyListState {
  final bool isMyList;

  const CheckMyListLoadedState(this.isMyList);
}

final class CheckMyListFailedState extends MyListState {
  final String message;

  const CheckMyListFailedState(this.message);
}

final class AddMyListLoadingState extends MyListState {}

final class AddMyListLoadedState extends MyListState {
  final Anime anime;

  const AddMyListLoadedState(this.anime);
}

final class AddMyListFailedState extends MyListState {
  final String message;

  const AddMyListFailedState(this.message);
}

final class DeleteMyListLoadingState extends MyListState {}

final class DeleteMyListLoadedState extends MyListState {
  final int malId;

  const DeleteMyListLoadedState(this.malId);
}

final class DeleteMyListFailedState extends MyListState {
  final String message;

  const DeleteMyListFailedState(this.message);
}

final class UploadMyListLoadingState extends MyListState {}

final class UploadMyListLoadedState extends MyListState {}

final class UploadMyListFailedState extends MyListState {
  final String message;

  const UploadMyListFailedState(this.message);
}

final class DownloadMyListLoadingState extends MyListState {}

final class DownloadMyListLoadedState extends MyListState {}

final class DownloadMyListFailedState extends MyListState {
  final String message;

  const DownloadMyListFailedState(this.message);
}

final class GetSharedMyListLoadingState extends MyListState {}

final class GetSharedMyListLoadedState extends MyListState {
  final SharedMylist data;

  const GetSharedMyListLoadedState(this.data);
}

final class GetSharedMyListEmptyState extends MyListState {}

final class GetSharedMyListFailedState extends MyListState {
  final String message;

  const GetSharedMyListFailedState(this.message);
}
