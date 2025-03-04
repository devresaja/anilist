// To parse this JSON data, do
//
//     final AnimeListResult = AnimeListResultFromJson(jsonString);

import 'dart:convert';

import 'package:anilist/global/model/anime.dart';

AnimeListResult animeListResultFromJson(String str) =>
    AnimeListResult.fromJson(json.decode(str));

String animeListResultResultToJson(AnimeListResult data) =>
    json.encode(data.toJson());

class AnimeListResult {
  Pagination? pagination;
  List<Anime>? data;

  AnimeListResult({
    this.pagination,
    this.data,
  });

  factory AnimeListResult.fromJson(Map<String, dynamic> json) =>
      AnimeListResult(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        data: json["data"] == null
            ? []
            : List<Anime>.from(json["data"]!.map((x) => Anime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Pagination {
  int? lastVisiblePage;
  bool? hasNextPage;
  int? currentPage;
  Items? items;

  Pagination({
    this.lastVisiblePage,
    this.hasNextPage,
    this.currentPage,
    this.items,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        lastVisiblePage: json["last_visible_page"],
        hasNextPage: json["has_next_page"],
        currentPage: json["current_page"],
        items: json["items"] == null ? null : Items.fromJson(json["items"]),
      );

  Map<String, dynamic> toJson() => {
        "last_visible_page": lastVisiblePage,
        "has_next_page": hasNextPage,
        "current_page": currentPage,
        "items": items?.toJson(),
      };
}

class Items {
  int? count;
  int? total;
  int? perPage;

  Items({
    this.count,
    this.total,
    this.perPage,
  });

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        count: json["count"],
        total: json["total"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "total": total,
        "per_page": perPage,
      };
}
