import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {

  final int movieId;

  CastingCards({ required this.movieId });



  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: ( BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {

        if ( !snapshot.hasData ) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }
        final List<Cast> cast = snapshot.data!;
         return Container(
            margin: EdgeInsets.only( bottom: 30),
            width: double.infinity,
            height: 180,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: ( BuildContext context, int index) => _CastCard( actor: cast[index])
            )
          );
        }
      );
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  _CastCard({ required this.actor });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric( horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage( this.actor.fullProfilePath ),
              height: 140,
              width: 100,
              fit: BoxFit.cover
            )
          ),
          SizedBox(height: 5,),
          Text(
            '${this.actor.name}', 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            )
        ],
      )
    );
  }
}