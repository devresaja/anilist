import 'package:anilist/global/model/anime.dart';
import 'package:anilist/modules/my_list/data/my_list_api.dart';
import 'package:anilist/modules/my_list/data/my_list_local_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_list_event.dart';
part 'my_list_state.dart';

class MyListBloc extends Bloc<MyListEvent, MyListState> {
  final _api = MyListApi();
  final _localApi = MyListLocalApi();

  MyListBloc() : super(MyListInitial()) {
    on<GetMyListEvent>(_getMyList);
    on<AddMyListEvent>(_addMyList);
    on<DeleteMyListEvent>(_deleteMyList);
    on<UploadMyListEvent>(_uploadMyList);
    on<DownloadMyListEvent>(_downloadMyList);
    on<CheckMyListEvent>(_checkMyList);
  }

  _checkMyList(CheckMyListEvent event, Emitter<MyListState> emit) async {
    emit(CheckMyListLoadingState());
    try {
      final response = await _localApi.checkMyList(event.anime.malId);
      emit(CheckMyListLoadedState(response));
    } catch (e) {
      emit(CheckMyListFailedState(e.toString()));
    }
  }

  _downloadMyList(DownloadMyListEvent event, Emitter<MyListState> emit) async {
    emit(DownloadMyListLoadingState());
    try {
      final animes = await _api.downloadMyList();

      await _localApi.replace(animes);

      emit(DownloadMyListLoadedState());
    } catch (e) {
      emit(DownloadMyListFailedState(e.toString()));
    }
  }

  _uploadMyList(UploadMyListEvent event, Emitter<MyListState> emit) async {
    emit(UploadMyListLoadingState());
    try {
      final response = await _localApi.get(getAll: true);

      await _api.uploadMyList(animeList: response.data ?? []);

      emit(UploadMyListLoadedState());
    } catch (e) {
      emit(UploadMyListFailedState(e.toString()));
    }
  }

  _deleteMyList(DeleteMyListEvent event, Emitter<MyListState> emit) async {
    emit(DeleteMyListLoadingState());
    try {
      await _localApi.delete(event.malId);
      emit(DeleteMyListLoadedState(event.malId));
    } catch (e) {
      emit(DeleteMyListFailedState(e.toString()));
    }
  }

  _addMyList(AddMyListEvent event, Emitter<MyListState> emit) async {
    emit(AddMyListLoadingState());
    try {
      await _localApi.add(event.anime);
      emit(AddMyListLoadedState(event.anime));
    } catch (e) {
      emit(AddMyListFailedState(e.toString()));
    }
  }

  _getMyList(GetMyListEvent event, Emitter<MyListState> emit) async {
    emit(GetMyListLoadingState());
    try {
      final response =
          await _localApi.get(page: event.page, limit: event.limit);

      if (response.data?.isNotEmpty ?? false) {
        emit(GetMyListLoadedState(
          totalItems: response.totalItems,
          data: response.data!,
        ));
        if (!response.hasNextPage) {
          emit(GetMyListMaximumState());
        }
      } else {
        emit(GetMyListEmptyState());
      }
    } catch (e) {
      emit(GetMyListFailedState(e.toString()));
    }
  }
}
