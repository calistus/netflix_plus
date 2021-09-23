import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:netflix_plus/model/movie_model.dart';
import 'package:netflix_plus/model/rating_model.dart';
import 'package:netflix_plus/repository/movie_repository.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MovieRepository moviesRepository;

  MoviesBloc({required this.moviesRepository}) : super(MoviesInitial());

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    if(event is SearchMovie){
      yield* _mapSearchEventToState(event);
    }
  }

  Stream<MoviesState> _mapSearchEventToState(SearchMovie event) async*{
    try{
      yield MoviesLoading();
      MovieModel? movies =  await moviesRepository.searchMovie(event.searchExpression);
      List<RatingModel> ratings = [];

       for(var movie in movies!.results){
         RatingModel? rating = await moviesRepository.fetchMovieRating(movie.id);
            ratings.add(rating!);
      }
      
      if(movies.errorMessage.isEmpty){
        yield MoviesLoaded(movies, ratings);
      }else{
        yield MoviesError(movies.errorMessage);
      }
    }catch(e){
     yield MoviesError(e.toString());
    }
  }
}
