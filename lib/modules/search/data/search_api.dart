import 'package:anilist/core/env/env.dart';
import 'package:anilist/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class SearchApi {
  final _apiService = ApiService();

  static String url = Env.url;
  static const String anime = '/anime';

  Future<Either<String, Response>> searchAnime(
      {required Map<String, dynamic> params}) async {
    final response = _apiService.get('$url$anime', params: params);
    return response;
  }
}
