// To parse this JSON data, do
//
//     final animeResult = animeResultFromJson(jsonString);

import 'dart:convert';

AnimeResult animeResultFromJson(String str) =>
    AnimeResult.fromJson(json.decode(str));

String animeResultToJson(AnimeResult data) => json.encode(data.toJson());

class AnimeResult {
  Anime? data;

  AnimeResult({
    this.data,
  });

  factory AnimeResult.fromJson(Map<String, dynamic> json) => AnimeResult(
        data: json["data"] == null ? null : Anime.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Anime {
  final int malId;
  final String? title;
  final String? titleEnglish;
  final String? titleJapanese;
  final String? type;
  final int? episodes;
  final double? score;
  final int? rank;
  final String? synopsis;
  final String? season;
  final int? year;
  final Images? images;
  final Trailer? trailer;
  final List<Genre>? genres;
  final DateTime createdAt;

  Anime({
    required this.malId,
    this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.type,
    this.episodes,
    this.score,
    this.rank,
    this.synopsis,
    this.season,
    this.year,
    this.images,
    this.trailer,
    this.genres,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json["mal_id"],
      title: json["title"],
      titleEnglish: json["title_english"],
      titleJapanese: json["title_japanese"],
      type: json["type"],
      episodes: json["episodes"],
      score: (json["score"] as num?)?.toDouble(),
      rank: json["rank"],
      synopsis: json["synopsis"],
      season: json["season"],
      year: json["year"],
      images: json["images"] != null
          ? (json["images"] is String
              ? Images.fromJson(jsonDecode(json["images"]))
              : Images.fromJson(json["images"]))
          : null,
      trailer: json["trailer"] != null
          ? (json["trailer"] is String
              ? Trailer.fromJson(jsonDecode(json["trailer"]))
              : Trailer.fromJson(json["trailer"]))
          : null,
      genres: json["genres"] != null
          ? json["genres"] is String
              ? (jsonDecode(json["genres"]) as List)
                  .map((genre) => Genre.fromJson(genre))
                  .toList()
              : (json["genres"] as List?)
                      ?.map((genre) => Genre.fromJson(genre))
                      .toList() ??
                  []
          : null,
      createdAt: _parseCreatedAt(json["created_at"]),
    );
  }

  static DateTime _parseCreatedAt(dynamic createdAt) {
    if (createdAt == null) return DateTime.now();

    if (createdAt is String) {
      return DateTime.tryParse(createdAt) ?? DateTime.now();
    }

    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "mal_id": malId,
      "title": title,
      "title_english": titleEnglish,
      "title_japanese": titleJapanese,
      "type": type,
      "episodes": episodes,
      "score": score,
      "rank": rank,
      "synopsis": synopsis,
      "season": season,
      "year": year,
      "images": images?.toJson(),
      "trailer": trailer?.toJson(),
      "genres": genres?.map((genre) => genre.toJson()).toList(),
      "created_at": createdAt.toIso8601String(),
    };
  }
}

class Images {
  final ImageFormat? jpg;
  final ImageFormat? webp;

  Images({this.jpg, this.webp});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: json["jpg"] != null ? ImageFormat.fromJson(json["jpg"]) : null,
      webp: json["webp"] != null ? ImageFormat.fromJson(json["webp"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "jpg": jpg?.toJson(),
      "webp": webp?.toJson(),
    };
  }
}

class ImageFormat {
  final String? imageUrl;
  final String? smallImageUrl;
  final String? largeImageUrl;

  ImageFormat({this.imageUrl, this.smallImageUrl, this.largeImageUrl});

  factory ImageFormat.fromJson(Map<String, dynamic> json) {
    return ImageFormat(
      imageUrl: json["image_url"],
      smallImageUrl: json["small_image_url"],
      largeImageUrl: json["large_image_url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image_url": imageUrl,
      "small_image_url": smallImageUrl,
      "large_image_url": largeImageUrl,
    };
  }
}

class Trailer {
  final String? youtubeId;
  final String? url;
  final String? embedUrl;
  final TrailerImages? images;

  Trailer({this.youtubeId, this.url, this.embedUrl, this.images});

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      youtubeId: json["youtube_id"],
      url: json["url"],
      embedUrl: json["embed_url"],
      images: json["images"] != null
          ? TrailerImages.fromJson(json["images"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "youtube_id": youtubeId,
      "url": url,
      "embed_url": embedUrl,
      "images": images?.toJson(),
    };
  }
}

class TrailerImages {
  final String? imageUrl;
  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final String? maximumImageUrl;

  TrailerImages({
    this.imageUrl,
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.maximumImageUrl,
  });

  factory TrailerImages.fromJson(Map<String, dynamic> json) {
    return TrailerImages(
      imageUrl: json["image_url"],
      smallImageUrl: json["small_image_url"],
      mediumImageUrl: json["medium_image_url"],
      largeImageUrl: json["large_image_url"],
      maximumImageUrl: json["maximum_image_url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image_url": imageUrl,
      "small_image_url": smallImageUrl,
      "medium_image_url": mediumImageUrl,
      "large_image_url": largeImageUrl,
      "maximum_image_url": maximumImageUrl,
    };
  }
}

class Genre {
  final int? malId;
  final String? type;
  final String? name;
  final String? url;

  Genre({this.malId, this.type, this.name, this.url});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      malId: json["mal_id"],
      type: json["type"],
      name: json["name"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mal_id": malId,
      "type": type,
      "name": name,
      "url": url,
    };
  }
}
