import 'dart:convert';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/global/model/pagination.dart';
import 'package:anilist/services/local_database_service.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart';

class MyListLocalApi {
  final LocalDatabaseService _dbInstance = LocalDatabaseService();

  Future<Either<String, Pagination<Anime>>> get({
    int page = 1,
    int limit = 10,
    bool getAll = false,
  }) async {
    try {
      final db = await _dbInstance.database;

      final List<Map<String, dynamic>> maps = await db.query(
        LocalDatabaseService.tableAnime,
        orderBy: 'createdAt DESC',
        limit: getAll ? null : limit,
        offset: getAll ? null : (page - 1) * limit,
      );

      final animeList = maps.map((map) => Anime.fromJson({...map})).toList();

      final totalResult = await db.rawQuery(
          'SELECT COUNT(*) as count FROM ${LocalDatabaseService.tableAnime}');
      final totalCount = Sqflite.firstIntValue(totalResult) ?? 0;
      final totalPages = (totalCount / limit).ceil();

      return Right(
        Pagination(
          data: animeList,
          currentPage: page,
          totalPages: totalPages,
          hasNextPage: page < totalPages,
        ),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> add(Anime anime) async {
    try {
      final db = await _dbInstance.database;
      await db.insert(
        LocalDatabaseService.tableAnime,
        {
          ...anime.toJson(),
          "images": jsonEncode(anime.images),
          "trailer": jsonEncode(anime.trailer),
          "genres": jsonEncode(anime.genres),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> delete(int malId) async {
    try {
      final db = await _dbInstance.database;
      await db.delete(LocalDatabaseService.tableAnime,
          where: 'malId = ?', whereArgs: [malId]);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> replace(List<Anime> newAnimeList) async {
    try {
      final db = await _dbInstance.database;
      await db.transaction((txn) async {
        // 1️⃣ Hapus semua data lama
        await txn.delete(LocalDatabaseService.tableAnime);

        // 2️⃣ Insert data baru secara batch
        final batch = txn.batch();
        for (var anime in newAnimeList) {
          batch.insert(
            LocalDatabaseService.tableAnime,
            {
              ...anime.toJson(),
              "images": jsonEncode(anime.images),
              "trailer": jsonEncode(anime.trailer),
              "genres": jsonEncode(anime.genres),
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await batch.commit(noResult: true);
      });
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
