import 'package:anilist/constant/app_constant.dart';
import 'package:anilist/modules/detail_anime/screen/detail_anime_screen.dart';
import 'package:anilist/modules/my_list/screen/shared_my_list_screen.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

enum DeepLinkType { mylist, anime }

class DeepLinkService {
  static final _appLinks = AppLinks();

  static void init(BuildContext context) {
    try {
      _appLinks.uriLinkStream.listen((Uri? link) {
        if (context.mounted) {
          _onDeepLinkReceived(context, link);
        }
      }, onError: (e) => showCustomSnackBar(e, isSuccess: false));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void _onDeepLinkReceived(BuildContext context, Uri? link) {
    if (link == null) return;

    if (!context.mounted) return;

    context.push(link.toString());
  }

  static Future<void> generateDeeplink({
    required DeepLinkType type,
    required String id,
  }) async {
    late String uri;

    switch (type) {
      case DeepLinkType.mylist:
        uri = '${AppConstant.webUrl}${SharedMyListScreen.path}/$id';
      case DeepLinkType.anime:
        uri = '${AppConstant.webUrl}${DetailAnimeScreen.path}/$id';
    }

    await Share.share(uri.toString());
  }
}
