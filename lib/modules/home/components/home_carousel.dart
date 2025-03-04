// import 'dart:developer';

// import 'package:anilist/modules/home/components/anime_card.dart';
// import 'package:anilist/modules/home/model/anime_card_model.dart';
// import 'package:anilist/widget/image/cached_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class HomeCarousel extends StatefulWidget {
//   const HomeCarousel({super.key});

//   @override
//   State<HomeCarousel> createState() => _HomeCarouselState();
// }

// class _HomeCarouselState extends State<HomeCarousel> {
//   final _animes = <AnimeCardModel>[
//     AnimeCardModel(
//         trailer: 'trailer',
//         imageUrl: 'https://cdn.myanimelist.net/images/anime/1584/143719.jpg',
//         score: 2,
//         title: 'title',
//         synopsis: 'synopsis',
//         genres: [],
//         type: 'type',
//         episode: 2),
//     AnimeCardModel(
//         trailer: 'trailer',
//         imageUrl: 'https://cdn.myanimelist.net/images/anime/1341/145349.jpg',
//         score: 2,
//         title: 'title',
//         synopsis: 'synopsis',
//         genres: [],
//         type: 'type',
//         episode: 2)
//   ];

//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         CachedImage(
//           imageUrl: _animes[_currentIndex].imageUrl,
//           fit: BoxFit.cover,
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: CarouselSlider(
//               items: _animes
//                   .map(
//                     (anime) => AnimeCard(
//                       trailer: anime.trailer,
//                       imageUrl: anime.imageUrl,
//                       score: anime.score,
//                       title: anime.title,
//                       synopsis: anime.synopsis,
//                       genres: anime.genres,
//                       type: anime.type,
//                       episode: anime.episode,
//                     ),
//                   )
//                   .toList(),
//               options: CarouselOptions(
//                 height: 190,
//                 aspectRatio: 16 / 9,
//                 viewportFraction: 0.4,
//                 initialPage: 0,
//                 enableInfiniteScroll: true,
//                 autoPlay: true,
//                 autoPlayInterval: Duration(seconds: 3),
//                 autoPlayAnimationDuration: Duration(milliseconds: 800),
//                 autoPlayCurve: Curves.fastOutSlowIn,
//                 enlargeCenterPage: true,
//                 enlargeFactor: 0.3,
//                 onPageChanged: (index, reason) {
//                   log('changed :$index');
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//                 scrollDirection: Axis.horizontal,
//               )),
//         )
//       ],
//     );
//   }
// }
