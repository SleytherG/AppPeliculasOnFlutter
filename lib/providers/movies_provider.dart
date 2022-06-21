import 'dart:async';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = '17a0bb7bfca43482850a4c74811ac5ec';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500)
  );

  final StreamController<List<Movie>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream => this._suggestionStreamController.stream;

  MoviesProvider() {

    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endPoint, [int page = 1]) async {
     final url = Uri.https(
      this._baseUrl, endPoint,{
        'api_key': this._apiKey, 
        'language': this._language, 
        'page': '$page'
        }
      );

    final response = await http.get(url);
    
    return response.body;
  }

  getOnDisplayMovies() async {

    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    this.onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage++;
    
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);

    this.onPopularMovies = [...onPopularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast( int movieId ) async {
    // Mantener el cast en memoria
    if ( moviesCast.containsKey(movieId) ) return moviesCast[movieId]!;


    // print('Pidiendo info al server');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson( jsonData );

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies( String query ) async {
    final url = Uri.https(
      this._baseUrl, '3/search/movie',{
        'api_key' : this._apiKey, 
        'language': this._language,
        'query'   : query
        }
      );

      final response = await http.get(url);
      final searchResponse = SearchResponse.fromJson( response.body );

      return searchResponse.results;
  }


  void getSuggestionsByQuery( String searchTerm ) {
    
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      // print('TENEMOS VALOR A BUSCAR => $value');
      final results = await this.searchMovies( value );
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
     });

     Future.delayed(Duration(milliseconds: 301)).then(( _ ) => timer.cancel());

  }


}
