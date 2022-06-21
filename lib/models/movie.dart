
import 'dart:convert';
import 'package:flutter/material.dart';

class Movie {
    Movie({
        required this.adult,
        this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    bool adult;
    String? backdropPath;
    List<int> genreIds;
    int id;
    String originalLanguage;
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    String? releaseDate;
    String title;
    bool video;
    double voteAverage;
    int voteCount;

    String? heroId;


    get fullPosterImg {
      if ( this.posterPath != null ) {
        return 'https://image.tmdb.org/t/p/w500${this.posterPath}';
      }
      return 'https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg';
    }

    get fullBackdropImg {
      if ( this.backdropPath != null ) {
        return 'https://image.tmdb.org/t/p/w500${this.backdropPath}';
      }
      return 'https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg';
    }


    factory Movie.fromJson(String str) => Movie.fromMap(json.decode(str));

    factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        adult             : json["adult"],
        backdropPath      : json["backdrop_path"],
        genreIds          : List<int>.from(json["genre_ids"].map((x) => x)),
        id                : json["id"],
        originalLanguage  : json["original_language"],
        originalTitle     : json["original_title"],
        overview          : json["overview"],
        popularity        : json["popularity"].toDouble(),
        posterPath        : json["poster_path"],
        releaseDate       : json["release_date"],
        title             : json["title"],
        video             : json["video"],
        voteAverage       : json["vote_average"].toDouble(),
        voteCount         : json["vote_count"],
    );
}