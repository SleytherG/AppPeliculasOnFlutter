import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Peliculas en Cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: MovieSearchDelegate()
            )
            ),
        ]
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Tarjetas Principales
              CardSwiper( 
                movies: moviesProvider.onDisplayMovies
              ),
              // Slider de Peliculas
              MovieSlider(
                movies: moviesProvider.onPopularMovies,
                title: 'Populares',
                onNextPage: ()  => moviesProvider.getPopularMovies()
               ),
            ],
          ),
        )
    );
  }
}
