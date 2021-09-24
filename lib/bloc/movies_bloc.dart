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

  MoviesBloc({required this.moviesRepository}) : super(MoviesInitial()) ;

  @override
  Stream<MoviesState> mapEventToState(
    MoviesEvent event,
  ) async* {
    if(event is InitApp){
      yield* _mapInitAppEventToState();
    }
    else if(event is SearchMovie){
      yield* _mapSearchEventToState(event);
    }
  }

  Stream<MoviesState> _mapInitAppEventToState() async*{
    try{
      yield MoviesLoading();

      List<Results> currentBookMark = await MovieRepository().getBookMarks();
      print(currentBookMark);

      if(currentBookMark.isEmpty){
        yield const MoviesInitial();
      }else{
        List<String> ratings = List.filled(currentBookMark.length, "0");
        yield MoviesLoaded(currentBookMark, ratings);
      }
    }catch(e){
      yield MoviesError(e.toString());
    }
  }

  Stream<MoviesState> _mapSearchEventToState(SearchMovie event) async*{
    try{
      yield MoviesLoading();
      MovieModel? movies =  await moviesRepository.searchMovie(event.searchExpression);
      List<String> ratings = [];

       for(var movie in movies!.results){
         RatingModel? rating = await moviesRepository.fetchMovieRating(movie.id);
            ratings.add(rating!.imDb);
      }
      
      if(movies.errorMessage.isEmpty){
        yield MoviesLoaded(movies.results, ratings);
      }else{
        yield MoviesError(movies.errorMessage);
      }
    }catch(e){
     yield MoviesError(e.toString());
    }
  }
}
