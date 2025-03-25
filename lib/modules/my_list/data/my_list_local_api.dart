import 'dart:convert';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/global/model/pagination.dart';
import 'package:anilist/services/local_database_service.dart';
import 'package:sqflite/sqflite.dart';

class MyListLocalApi {
  final LocalDatabaseService _dbInstance = LocalDatabaseService();

  Future<bool> checkMyList(int malId) async {
    final db = await _dbInstance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      LocalDatabaseService.tableAnime,
      where: 'mal_id = ?',
      whereArgs: [malId],
      limit: 1,
    );

    if (maps.isEmpty) return false;

    return true;
  }

  Future<Pagination<Anime>> get({
    int page = 1,
    int limit = 10,
    bool getAll = false,
  }) async {
    final db = await _dbInstance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      LocalDatabaseService.tableAnime,
      orderBy: 'created_at DESC',
      limit: getAll ? null : limit,
      offset: getAll ? null : (page - 1) * limit,
    );

    final animeList = maps.map((map) => Anime.fromJson({...map})).toList();

    final totalResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${LocalDatabaseService.tableAnime}');
    final totalItems = Sqflite.firstIntValue(totalResult) ?? 0;
    final totalPages = (totalItems / limit).ceil();

    return Pagination(
      data: animeList,
      totalItems: totalItems,
      currentPage: page,
      totalPages: totalPages,
      hasNextPage: page < totalPages,
    );
  }

  Future<void> add(Anime anime) async {
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
  }

  Future<void> delete(int malId) async {
    final db = await _dbInstance.database;
    await db.delete(LocalDatabaseService.tableAnime,
        where: 'mal_id = ?', whereArgs: [malId]);
  }

  Future<void> replace(List<Anime> newAnimeList) async {
    final db = await _dbInstance.database;
    await db.transaction((txn) async {
      await txn.delete(LocalDatabaseService.tableAnime);

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
  }
}
