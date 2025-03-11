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
  }

  _deleteMyList(DeleteMyListEvent event, Emitter<MyListState> emit) async {
    emit(DeleteMyListLoadingState());
    try {
      final response = await _localApi.delete(event.malId);
      response.fold(
        (left) => emit(DeleteMyListFailedState(left)),
        (right) => emit(DeleteMyListLoadedState()),
      );
    } catch (e) {
      emit(DeleteMyListFailedState(e.toString()));
    }
  }

  _addMyList(AddMyListEvent event, Emitter<MyListState> emit) async {
    emit(AddMyListLoadingState());
    try {
      final response = await _localApi.add(event.anime);
      response.fold(
        (left) => emit(AddMyListFailedState(left)),
        (right) => emit(AddMyListLoadedState()),
      );
    } catch (e) {
      emit(AddMyListFailedState(e.toString()));
    }
  }

  _getMyList(GetMyListEvent event, Emitter<MyListState> emit) async {
    emit(GetMyListLoadingState());
    try {
      final response =
          await _localApi.get(page: event.page, limit: event.limit);
      response.fold(
        (left) => emit(GetMyListFailedState(left)),
        (right) {
          if (right.data?.isNotEmpty ?? false) {
            emit(GetMyListLoadedState(right.data!));
            if (!right.hasNextPage) {
              emit(GetMyListMaximumState());
            }
          } else {
            emit(GetMyListEmptyState());
          }
        },
      );
    } catch (e) {
      emit(GetMyListFailedState(e.toString()));
    }
  }
}
