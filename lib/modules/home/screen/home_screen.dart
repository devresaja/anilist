import 'package:anilist/constant/app_color.dart';
import 'package:anilist/constant/divider.dart';
import 'package:anilist/core/routes/route.dart';
import 'package:anilist/global/widget/speech_to_text_button.dart';
import 'package:anilist/modules/home/components/anime_list.dart';
import 'package:anilist/modules/home/components/home_header.dart';
import 'package:anilist/modules/home/components/home_random.dart';
import 'package:anilist/modules/search/screen/search_screen.dart';
import 'package:anilist/utils/view_utils.dart';
import 'package:anilist/widget/image/cached_image.dart';
import 'package:anilist/widget/wrapper/invisible_expanded_header.dart';
import 'package:anilist/widget/text/custom_search_bar.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String path = 'homeScreen';

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
        padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom +
                kBottomNavigationBarHeight +
                40),
        child: Column(
          children: [
            divide16,
            const HomeHeader(title: 'Ongoing Anime'),
            divide4,
            const AnimeListWidget(
              animeListType: AnimeListType.ongoing,
            ),
            HomeRandom(),
            divide10,
            const HomeHeader(title: 'Top Anime'),
            divide4,
            const AnimeListWidget(
              animeListType: AnimeListType.top,
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
        systemOverlayStyle: systemUiOverlayStyleLight.copyWith(
            statusBarColor: Colors.transparent),
        backgroundColor: AppColor.secondary,
        pinned: true,
        snap: false,
        floating: false,
        expandedHeight: 180,
        flexibleSpace: Stack(
          children: [
            FlexibleSpaceBar(
                title: InvisibleExpandedHeader(
                  child: Container(),
                ),
                background: Stack(
                  children: [
                    Opacity(
                      opacity: 0.3,
                      child: CachedImage(
                          width: double.infinity,
                          imageUrl:
                              'https://th.bing.com/th/id/OIP.Gqau9w1vpH0OPLw2YxPQdAHaFN?rs=1&pid=ImgDetMain'),
                    ),
                  ],
                )),
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
                      hintText: 'Search title',
                      onSubmitted: (search) {
                        pushTo(context, screen: SearchScreen(search: search));
                      },
                    ),
                  ),
                  divideW6,
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SpeechToTextButton(
                        onResult: (search) {
                          if (ModalRoute.of(context)?.isCurrent ?? false) {
                            pushTo(context,
                                screen: SearchScreen(search: search));
                          }
                        },
                      ))
                ],
              ),
            )
          ],
        ));
  }
}
