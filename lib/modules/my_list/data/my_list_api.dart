import 'dart:developer';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyListApi {
  final _firestore = FirebaseFirestore.instance;

  Future<void> _uploadUserData() async {
    final userData = await LocalStorageService.getUserData();

    log('Uploading user data for user: ${userData!.userId}');

    await _firestore.collection('users').doc(userData.userId).set(
      {
        'user_id': userData.userId,
        'name': userData.name,
        'email': userData.email,
        'avatar': userData.avatar,
        "expires_at": Timestamp.fromDate(DateTime.now().add(Duration(days: 14)))
      },
    );
  }

  /// 🔹 Upload semua list anime user ke Firestore dengan Paging
  Future<void> uploadMyList({
    required List<Anime> animeList,
  }) async {
    await _uploadUserData();

    final userData = await LocalStorageService.getUserData();

    final userId = userData!.userId;
    const int maxPerPage = 120;

    log('Uploading anime list for user: $userId');

    final batch = _firestore.batch();
    final userCollection =
        _firestore.collection('users').doc(userId).collection('anime_list');

    // Bagi data ke dalam beberapa dokumen
    int page = 1;
    for (int i = 0; i < animeList.length; i += maxPerPage) {
      final sublist = animeList.sublist(
          i,
          (i + maxPerPage > animeList.length)
              ? animeList.length
              : i + maxPerPage);
      final pageDoc = userCollection.doc("page_$page");

      batch.set(pageDoc, {
        "page": page,
        "data": sublist.map((anime) => anime.toJson()).toList(),
        "expires_at": Timestamp.fromDate(DateTime.now().add(Duration(days: 14)))
      });

      page++;
    }

    await batch.commit();
  }

  /// 🔹 Download semua list anime user dari Firestore dengan Paging
  Future<List<Anime>> downloadMyList() async {
    final userData = await LocalStorageService.getUserData();
    final userId = userData!.userId;

    log('Downloading anime list for user: $userId');

    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('anime_list')
        .orderBy('page')
        .get();

    log('Total Documents Read: ${querySnapshot.docs.length}');

    // Ambil semua data tanpa loop manual
    final animeList = querySnapshot.docs
        .expand((doc) => (doc.data()['data'] as List<dynamic>)
            .map((json) => Anime.fromJson(json)))
        .toList();

    return animeList;
  }
}
