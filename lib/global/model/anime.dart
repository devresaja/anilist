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
  int? malId;
  String? url;
  DataImages? images;
  Trailer? trailer;
  bool? approved;
  List<Title>? titles;
  String? title;
  String? titleEnglish;
  String? titleJapanese;
  List<dynamic>? titleSynonyms;
  String? type;
  String? source;
  int? episodes;
  String? status;
  bool? airing;
  Aired? aired;
  String? duration;
  String? rating;
  double? score;
  int? scoredBy;
  int? rank;
  int? popularity;
  int? members;
  int? favorites;
  String? synopsis;
  String? background;
  String? season;
  int? year;
  Broadcast? broadcast;
  List<Demographic>? producers;
  List<Demographic>? licensors;
  List<Demographic>? studios;
  List<Demographic>? genres;
  List<dynamic>? explicitGenres;
  List<dynamic>? themes;
  List<Demographic>? demographics;

  Anime({
    this.malId,
    this.url,
    this.images,
    this.trailer,
    this.approved,
    this.titles,
    this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.titleSynonyms,
    this.type,
    this.source,
    this.episodes,
    this.status,
    this.airing,
    this.aired,
    this.duration,
    this.rating,
    this.score,
    this.scoredBy,
    this.rank,
    this.popularity,
    this.members,
    this.favorites,
    this.synopsis,
    this.background,
    this.season,
    this.year,
    this.broadcast,
    this.producers,
    this.licensors,
    this.studios,
    this.genres,
    this.explicitGenres,
    this.themes,
    this.demographics,
  });

  factory Anime.fromJson(Map<String, dynamic> json) => Anime(
        malId: json["mal_id"],
        url: json["url"],
        images:
            json["images"] == null ? null : DataImages.fromJson(json["images"]),
        trailer:
            json["trailer"] == null ? null : Trailer.fromJson(json["trailer"]),
        approved: json["approved"],
        titles: json["titles"] == null
            ? []
            : List<Title>.from(json["titles"]!.map((x) => Title.fromJson(x))),
        title: json["title"],
        titleEnglish: json["title_english"],
        titleJapanese: json["title_japanese"],
        titleSynonyms: json["title_synonyms"] == null
            ? []
            : List<dynamic>.from(json["title_synonyms"]!.map((x) => x)),
        type: json["type"],
        source: json["source"],
        episodes: json["episodes"],
        status: json["status"],
        airing: json["airing"],
        aired: json["aired"] == null ? null : Aired.fromJson(json["aired"]),
        duration: json["duration"],
        rating: json["rating"],
        score: json["score"]?.toDouble(),
        scoredBy: json["scored_by"],
        rank: json["rank"],
        popularity: json["popularity"],
        members: json["members"],
        favorites: json["favorites"],
        synopsis: json["synopsis"],
        background: json["background"],
        season: json["season"],
        year: json["year"],
        broadcast: json["broadcast"] == null
            ? null
            : Broadcast.fromJson(json["broadcast"]),
        producers: json["producers"] == null
            ? []
            : List<Demographic>.from(
                json["producers"]!.map((x) => Demographic.fromJson(x))),
        licensors: json["licensors"] == null
            ? []
            : List<Demographic>.from(
                json["licensors"]!.map((x) => Demographic.fromJson(x))),
        studios: json["studios"] == null
            ? []
            : List<Demographic>.from(
                json["studios"]!.map((x) => Demographic.fromJson(x))),
        genres: json["genres"] == null
            ? []
            : List<Demographic>.from(
                json["genres"]!.map((x) => Demographic.fromJson(x))),
        explicitGenres: json["explicit_genres"] == null
            ? []
            : List<dynamic>.from(json["explicit_genres"]!.map((x) => x)),
        themes: json["themes"] == null
            ? []
            : List<dynamic>.from(json["themes"]!.map((x) => x)),
        demographics: json["demographics"] == null
            ? []
            : List<Demographic>.from(
                json["demographics"]!.map((x) => Demographic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": images?.toJson(),
        "trailer": trailer?.toJson(),
        "approved": approved,
        "titles": titles == null
            ? []
            : List<dynamic>.from(titles!.map((x) => x.toJson())),
        "title": title,
        "title_english": titleEnglish,
        "title_japanese": titleJapanese,
        "title_synonyms": titleSynonyms == null
            ? []
            : List<dynamic>.from(titleSynonyms!.map((x) => x)),
        "type": type,
        "source": source,
        "episodes": episodes,
        "status": status,
        "airing": airing,
        "aired": aired?.toJson(),
        "duration": duration,
        "rating": rating,
        "score": score,
        "scored_by": scoredBy,
        "rank": rank,
        "popularity": popularity,
        "members": members,
        "favorites": favorites,
        "synopsis": synopsis,
        "background": background,
        "season": season,
        "year": year,
        "broadcast": broadcast?.toJson(),
        "producers": producers == null
            ? []
            : List<dynamic>.from(producers!.map((x) => x.toJson())),
        "licensors": licensors == null
            ? []
            : List<dynamic>.from(licensors!.map((x) => x.toJson())),
        "studios": studios == null
            ? []
            : List<dynamic>.from(studios!.map((x) => x.toJson())),
        "genres": genres == null
            ? []
            : List<dynamic>.from(genres!.map((x) => x.toJson())),
        "explicit_genres": explicitGenres == null
            ? []
            : List<dynamic>.from(explicitGenres!.map((x) => x)),
        "themes":
            themes == null ? [] : List<dynamic>.from(themes!.map((x) => x)),
        "demographics": demographics == null
            ? []
            : List<dynamic>.from(demographics!.map((x) => x.toJson())),
      };
}

class Aired {
  DateTime? from;
  dynamic to;
  Prop? prop;
  String? string;

  Aired({
    this.from,
    this.to,
    this.prop,
    this.string,
  });

  factory Aired.fromJson(Map<String, dynamic> json) => Aired(
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"],
        prop: json["prop"] == null ? null : Prop.fromJson(json["prop"]),
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "from": from?.toIso8601String(),
        "to": to,
        "prop": prop?.toJson(),
        "string": string,
      };
}

class Prop {
  From? from;
  To? to;

  Prop({
    this.from,
    this.to,
  });

  factory Prop.fromJson(Map<String, dynamic> json) => Prop(
        from: json["from"] == null ? null : From.fromJson(json["from"]),
        to: json["to"] == null ? null : To.fromJson(json["to"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from?.toJson(),
        "to": to?.toJson(),
      };
}

class From {
  int? day;
  int? month;
  int? year;

  From({
    this.day,
    this.month,
    this.year,
  });

  factory From.fromJson(Map<String, dynamic> json) => From(
        day: json["day"],
        month: json["month"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
      };
}

class To {
  dynamic day;
  dynamic month;
  dynamic year;

  To({
    this.day,
    this.month,
    this.year,
  });

  factory To.fromJson(Map<String, dynamic> json) => To(
        day: json["day"],
        month: json["month"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
      };
}

class Broadcast {
  String? day;
  String? time;
  String? timezone;
  String? string;

  Broadcast({
    this.day,
    this.time,
    this.timezone,
    this.string,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) => Broadcast(
        day: json["day"],
        time: json["time"],
        timezone: json["timezone"],
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "time": time,
        "timezone": timezone,
        "string": string,
      };
}

class Demographic {
  int? malId;
  String? type;
  String? name;
  String? url;

  Demographic({
    this.malId,
    this.type,
    this.name,
    this.url,
  });

  factory Demographic.fromJson(Map<String, dynamic> json) => Demographic(
        malId: json["mal_id"],
        type: json["type"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "type": type,
        "name": name,
        "url": url,
      };
}

class DataImages {
  Jpg? jpg;
  Webp? webp;

  DataImages({
    this.jpg,
    this.webp,
  });

  factory DataImages.fromJson(Map<String, dynamic> json) => DataImages(
        jpg: json["jpg"] == null ? null : Jpg.fromJson(json["jpg"]),
        webp: json["webp"] == null ? null : Webp.fromJson(json["webp"]),
      );

  Map<String, dynamic> toJson() => {
        "jpg": jpg?.toJson(),
        "webp": webp?.toJson(),
      };
}

class Jpg {
  String? imageUrl;
  String? smallImageUrl;
  String? largeImageUrl;

  Jpg({
    this.imageUrl,
    this.smallImageUrl,
    this.largeImageUrl,
  });

  factory Jpg.fromJson(Map<String, dynamic> json) => Jpg(
        imageUrl: json["image_url"],
        smallImageUrl: json["small_image_url"],
        largeImageUrl: json["large_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
        "large_image_url": largeImageUrl,
      };
}

class Webp {
  String? imageUrl;
  String? smallImageUrl;
  String? largeImageUrl;

  Webp({
    this.imageUrl,
    this.smallImageUrl,
    this.largeImageUrl,
  });

  factory Webp.fromJson(Map<String, dynamic> json) => Webp(
        imageUrl: json["image_url"],
        smallImageUrl: json["small_image_url"],
        largeImageUrl: json["large_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
        "large_image_url": largeImageUrl,
      };
}

class Title {
  String? type;
  String? title;

  Title({
    this.type,
    this.title,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        type: json["type"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
      };
}

class Trailer {
  String? youtubeId;
  String? url;
  String? embedUrl;
  TrailerImages? images;

  Trailer({
    this.youtubeId,
    this.url,
    this.embedUrl,
    this.images,
  });

  factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
        youtubeId: json["youtube_id"],
        url: json["url"],
        embedUrl: json["embed_url"],
        images: json["images"] == null
            ? null
            : TrailerImages.fromJson(json["images"]),
      );

  Map<String, dynamic> toJson() => {
        "youtube_id": youtubeId,
        "url": url,
        "embed_url": embedUrl,
        "images": images?.toJson(),
      };
}

class TrailerImages {
  String? imageUrl;
  String? smallImageUrl;
  String? mediumImageUrl;
  String? largeImageUrl;
  String? maximumImageUrl;

  TrailerImages({
    this.imageUrl,
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.maximumImageUrl,
  });

  factory TrailerImages.fromJson(Map<String, dynamic> json) => TrailerImages(
        imageUrl: json["image_url"],
        smallImageUrl: json["small_image_url"],
        mediumImageUrl: json["medium_image_url"],
        largeImageUrl: json["large_image_url"],
        maximumImageUrl: json["maximum_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
        "medium_image_url": mediumImageUrl,
        "large_image_url": largeImageUrl,
        "maximum_image_url": maximumImageUrl,
      };
}
