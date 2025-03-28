part of 'my_list_bloc.dart';

sealed class MyListEvent extends Equatable {
  const MyListEvent();

  @override
  List<Object> get props => [];
}

final class GetMyListEvent extends MyListEvent {
  final int page;
  final int limit;

  const GetMyListEvent({
    required this.page,
    required this.limit,
  });
}

final class CheckMyListEvent extends MyListEvent {
  final Anime anime;

  const CheckMyListEvent(this.anime);
}

final class AddMyListEvent extends MyListEvent {
  final Anime anime;

  const AddMyListEvent(this.anime);
}

final class DeleteMyListEvent extends MyListEvent {
  final int malId;

  const DeleteMyListEvent(this.malId);
}

final class UploadMyListEvent extends MyListEvent {}

final class DownloadMyListEvent extends MyListEvent {}
