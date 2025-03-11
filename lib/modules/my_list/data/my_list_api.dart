import 'dart:developer';
import 'package:anilist/global/model/anime.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';

class MyListApi {
  final _firestore = FirebaseFirestore.instance;

  /// 🔹 Upload semua list anime user ke Firestore (overwrite dengan hapus koleksi)
  Future<Either<String, void>> uploadAnimeList({
    required String userId,
    required List<Anime> animeList,
  }) async {
    try {
      log('Uploading anime list for user: $userId');

      // Hapus koleksi lama
      final deleteResult = await _deleteAnimeCollection(userId);
      if (deleteResult.isLeft) return deleteResult;

      // Tambah data baru pakai batch
      final batch = _firestore.batch();
      final animeCollection = _getUserAnimeCollection(userId);

      for (var anime in animeList) {
        batch.set(animeCollection.doc(anime.malId.toString()), anime);
      }

      await batch.commit();
      return const Right(null);
    } catch (e) {
      log('Error uploading anime list: $e');
      return Left(e.toString());
    }
  }

  /// 🔹 Download semua list anime user dari Firestore
  Future<Either<String, List<Anime>>> downloadAnimeList({
    required String userId,
  }) async {
    try {
      log('Downloading anime list for user: $userId');
      final querySnapshot = await _getUserAnimeCollection(userId)
          .orderBy('createdAt', descending: true)
          .get();

      final animeList = querySnapshot.docs.map((doc) => doc.data()).toList();
      return Right(animeList);
    } catch (e) {
      log('Error downloading anime list: $e');
      return Left(e.toString());
    }
  }

  /// 🔹 Hapus seluruh koleksi anime user dari Firestore
  Future<Either<String, void>> _deleteAnimeCollection(String userId) async {
    try {
      log('Deleting anime collection for user: $userId');
      final animeCollection = _getUserAnimeCollection(userId);

      final snapshot = await animeCollection.get();
      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return const Right(null);
    } catch (e) {
      log('Error deleting anime collection: $e');
      return Left(e.toString());
    }
  }

  /// 🔹 Referensi koleksi anime user dengan `withConverter()`
  CollectionReference<Anime> _getUserAnimeCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('animeList')
        .withConverter<Anime>(
          fromFirestore: (snapshot, _) => Anime.fromJson(snapshot.data()!),
          toFirestore: (anime, _) => anime.toJson(),
        );
  }
}
