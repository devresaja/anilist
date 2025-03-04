import 'package:anilist/core/env/env.dart';
import 'package:anilist/modules/home/components/anime_list.dart';
import 'package:anilist/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class HomeApi {
  final _apiService = ApiService();

  static String url = Env.url;
  static const String topAnime = '/top/anime';
  static const String ongoing = '/seasons/now';
  static const String random = '/random/anime';

  Future<Either<String, Response>> getAnimeList(
      {required AnimeListType animeListType,
      Map<String, dynamic>? params}) async {
    String dynamicUrl = url;
    switch (animeListType) {
      case AnimeListType.ongoing:
        dynamicUrl += ongoing;
        break;
      case AnimeListType.top:
        dynamicUrl += topAnime;
        break;
    }
    final response = _apiService.get(dynamicUrl, params: params);
    return response;
  }

  Future<Either<String, Response>> getRandomAnime() async {
    final response = _apiService.get(
      '$url$random',
      params: <String, dynamic>{
        "sfw": true,
      },
    );
    return response;
  }
}
