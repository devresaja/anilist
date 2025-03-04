import 'dart:convert';
import 'dart:developer';

import 'package:anilist/core/response/response_error.dart';
import 'package:anilist/utils/logging.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  final Dio _dio = Dio();

  ApiService._internal() {
    _dio.options.headers['Accept'] = '*/*';
    _dio.options.headers['Accept'] = 'application/json';
  }

  factory ApiService() {
    return _instance;
  }

  Future<Either<String, Response>> get(String url,
      {Map<String, dynamic>? params}) async {
    try {
      log('get url: $url');
      if (params != null) {
        logJson(params);
      }
      final response = await _dio.get(url, queryParameters: params);
      return Right(response);
    } on DioException catch (e) {
      log('get dio exception url: $url');
      return Left(e.response != null
          ? responseErrorFromJson(jsonEncode(e.response!.data)).error ??
              e.response!.statusMessage
          : e.toString());
    } catch (e) {
      log('get catch error url: $url');
      log(e.toString());
      return Left(e.toString());
    }
  }
}
