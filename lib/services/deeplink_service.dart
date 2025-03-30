import 'package:anilist/core/routes/route.dart';
import 'package:anilist/modules/detail_anime/screen/detail_anime_screen.dart';
import 'package:anilist/modules/my_list/screen/shared_my_list_screen.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

enum DeepLinkType {
  mylist,
  anime,
}

extension DeepLinkTypeExtension on DeepLinkType {
  String get value {
    switch (this) {
      case DeepLinkType.mylist:
        return 'mylist';
      case DeepLinkType.anime:
        return 'anime';
    }
  }

  static DeepLinkType? fromValue(String? value) {
    if (value == null) return null;
    return DeepLinkType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DeepLinkType.anime,
    );
  }
}

class DeepLinkService {
  static final _appLinks = AppLinks();

  static void init(BuildContext context) {
    try {
      _appLinks.uriLinkStream.listen(
        (Uri? link) {
          if (context.mounted) {
            _onDeepLinkReceived(context, link);
          }
        },
        onError: (e) => showCustomSnackBar(e, isSuccess: false),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void _onDeepLinkReceived(BuildContext context, Uri? link) {
    if (link == null) return;

    final id = link.queryParameters['id'];
    final type = DeepLinkTypeExtension.fromValue(link.queryParameters['type']);

    if (id == null || type == null) return;
    if (!context.mounted) return;

    _handleDeepLink(context, type, id);
  }

  static Future<void> generateDeeplink({
    required DeepLinkType type,
    required String id,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'anilist-433306.firebaseapp.com',
      path: '/anilist',
      queryParameters: {
        'type': type.name,
        'id': id,
      },
    );

    await Share.share(uri.toString());
  }

  static void _handleDeepLink(
      BuildContext context, DeepLinkType type, String id) {
    switch (type) {
      case DeepLinkType.mylist:
        pushTo(context,
            screen: SharedMyListScreen(argument: SharedMyListArgument(id)),
            routeName: SharedMyListScreen.path);
      case DeepLinkType.anime:
        pushTo(context,
            screen: DetailAnimeScreen(
                argument: DetailAnimeArgument(animeId: int.parse(id))),
            routeName: DetailAnimeScreen.path);
    }
  }
}
