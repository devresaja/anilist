import 'package:anilist/core/theme/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/locale/locale_keys.g.dart';
import 'package:anilist/extension/view_extension.dart';
import 'package:anilist/global/bloc/app_bloc/app_bloc.dart';
import 'package:anilist/global/widget/speech_to_text_button.dart';
import 'package:anilist/modules/home/components/anime_list.dart';
import 'package:anilist/modules/home/components/home_header.dart';
import 'package:anilist/modules/home/components/home_random.dart';
import 'package:anilist/modules/search/screen/search_screen.dart';
import 'package:anilist/services/analytic_service.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/image/cached_image.dart';
import 'package:anilist/widget/wrapper/invisible_expanded_header.dart';
import 'package:anilist/widget/text/custom_search_bar.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String path = '/home';

  @override
  Widget build(BuildContext context) {
    return ExtendedNestedScrollView(
      pinnedHeaderSliverHeightBuilder: () {
        return MediaQuery.paddingOf(context).top + 70;
      },
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _buildAppBar(context),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            divide16,
            const HomeHeader(title: LocaleKeys.ongoing_anime),
            divide4,
            const AnimeListWidget(animeListType: AnimeListType.ongoing),
            HomeRandom(),
            divide10,
            const HomeHeader(title: LocaleKeys.top_anime),
            divide4,
            const AnimeListWidget(animeListType: AnimeListType.top),
            if (!context.isWideScreen)
              SizedBox(
                height:
                    kBottomNavigationBarHeight +
                    MediaQuery.paddingOf(context).bottom,
              )
            else
              divide16,
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle:
          (context.read<AppBloc>().state.isDarkMode
                  ? systemUiOverlayStyleLight
                  : systemUiOverlayStyleDark)
              .copyWith(statusBarColor: Colors.transparent),
      backgroundColor: AppColor.secondary,
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 180,
      leading: Container(),
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            title: InvisibleExpandedHeader(child: Container()),
            background: Stack(
              children: [
                Opacity(
                  opacity: 0.4,
                  child: CachedImage(
                    width: double.infinity,
                    imageUrl:
                        'https://th.bing.com/th/id/OIP.Gqau9w1vpH0OPLw2YxPQdAHaFN?rs=1&pid=ImgDetMain',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                divideW16,
                Flexible(
                  child: CustomSearchBar(
                    height: 46,
                    controller: TextEditingController(),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    withPaddingHorizontal: false,
                    hintText: LocaleKeys.search_title,
                    onSubmitted: (search) {
                      _pushToSearchScreen(context: context, search: search);
                    },
                  ),
                ),
                divideW6,
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SpeechToTextButton(
                    onResult: (search) {
                      if (ModalRoute.of(context)?.isCurrent ?? false) {
                        AnalyticsService.instance.logSearch(search: search);
                        _pushToSearchScreen(context: context, search: search);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pushToSearchScreen({
    required BuildContext context,
    required String search,
  }) {
    context.pushNamed(
      SearchScreen.name,
      queryParameters: SearchArgument(search: search).toQueryParams(),
    );
  }
}
