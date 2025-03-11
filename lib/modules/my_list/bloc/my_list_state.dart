part of 'my_list_bloc.dart';

sealed class MyListState extends Equatable {
  const MyListState();

  @override
  List<Object> get props => [];
}

final class MyListInitial extends MyListState {}

final class GetMyListLoadingState extends MyListState {}

final class GetMyListLoadedState extends MyListState {
  final List<Anime> data;

  const GetMyListLoadedState(this.data);
}

final class GetMyListEmptyState extends MyListState {}

final class GetMyListMaximumState extends MyListState {}

final class GetMyListFailedState extends MyListState {
  final String message;

  const GetMyListFailedState(this.message);
}

final class AddMyListLoadingState extends MyListState {}

final class AddMyListLoadedState extends MyListState {}

final class AddMyListFailedState extends MyListState {
  final String message;

  const AddMyListFailedState(this.message);
}

final class DeleteMyListLoadingState extends MyListState {}

final class DeleteMyListLoadedState extends MyListState {}

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
