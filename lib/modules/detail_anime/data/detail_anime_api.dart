import 'package:anilist/core/env/env.dart';
import 'package:anilist/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class DetailAnimeApi {
  final _apiService = ApiService();

  static String url = Env.url;
  static const String anime = '/anime';

  Future<Either<String, Response>> getAnimeById(int animeId) async {
    final response = _apiService.get('$url$anime/$animeId');
    return response;
  }
}
