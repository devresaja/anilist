import 'dart:developer';
import 'package:anilist/global/model/anime.dart';
import 'package:anilist/global/model/user_data.dart';
import 'package:anilist/modules/my_list/model/shared_mylist.dart';
import 'package:anilist/services/local_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyListApi {
  final _firestore = FirebaseFirestore.instance;

  Future<void> uploadMyList({
    required List<Anime> animeList,
  }) async {
    await _uploadUserData();

    final userData = await LocalStorageService.getUserData();

    final userId = userData!.userId;
    const int maxPerPage = 150;

    log('Uploading anime list for user: $userId');

    final batch = _firestore.batch();
    final userCollection =
        _firestore.collection('users').doc(userId).collection('anime_list');

    // Delete all and return if list empty
    if (animeList.isEmpty) {
      final snapshot = await userCollection.get();
      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return;
    }

    // Split data per page
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

    final animeList = querySnapshot.docs
        .expand((doc) => (doc.data()['data'] as List<dynamic>)
            .map((json) => Anime.fromJson(json)))
        .toList();

    return animeList;
  }

  Future<SharedMylist> getSharedMylist({required String userId}) async {
    log('Get SharedMylist for user: $userId');

    // Get UserData
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('Shared list not found');
    }

    final userData = UserData.fromJson(userDoc.data()!);

    // Get anime list
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('anime_list')
        .orderBy('page')
        .get();

    final animeList = querySnapshot.docs
        .expand((doc) => (doc.data()['data'] as List<dynamic>)
            .map((json) => Anime.fromJson(json)))
        .toList();

    animeList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return SharedMylist(
      userData: userData,
      data: animeList,
    );
  }
}
