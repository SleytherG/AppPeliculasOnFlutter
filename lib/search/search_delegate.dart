import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:provider/provider.dart';
import 'package:peliculas/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate {


  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = ''
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Build Results');
  }

  Widget _emptyContainer() {
    return Container(
        child: Center(
          child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 130)
        )
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if ( query.isEmpty ) {
      return _emptyContainer();
    }

    // print('http request');

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery( query );

    // Without Debouncer
    // return FutureBuilder(
    //   future: moviesProvider.searchMovies(query),
    //   builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {

    //     if ( !snapshot.hasData ) {
    //       return _emptyContainer();
    //     }

    //     final movies = snapshot.data!;

    //     return ListView.builder(
    //       itemCount: movies.length ,
    //       itemBuilder: ( BuildContext context, int index ) =>_MovieItem(movie: movies[index])
    //     );
    //   }
    // );

    // With Debouncer
    return StreamBuilder(
      stream: moviesProvider.suggestionsStream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {

        if ( !snapshot.hasData ) {
          return _emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length ,
          itemBuilder: ( BuildContext context, int index ) =>_MovieItem(movie: movies[index])
        );
      }
    );
  }
  
}

class _MovieItem extends StatelessWidget {

  final Movie movie;

  _MovieItem({ required this.movie } );



  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${ movie.id }';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            placeholder: AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage( movie.fullPosterImg),
            width: 50,
            fit: BoxFit.contain
          ),
        ),
      ),
      title: Text( movie.title ),
      subtitle: Text( movie.originalTitle ),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      }
    );
  }
}