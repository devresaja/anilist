import 'package:anilist/global/model/anime.dart';
import 'package:anilist/global/model/user_data.dart';

class SharedMylist {
  final UserData userData;
  final List<Anime> data;

  SharedMylist({
    required this.userData,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_data': userData.toJson(),
      'data': data.map((x) => x.toJson()).toList(),
    };
  }

  factory SharedMylist.fromJson(Map<String, dynamic> map) {
    return SharedMylist(
      userData: UserData.fromJson(map['user_data'] as Map<String, dynamic>),
      data: (map['data'] as List<dynamic>)
          .map((x) => Anime.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}
