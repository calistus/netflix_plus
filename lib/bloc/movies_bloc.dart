import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:netflix_plus/model/movie_model.dart';
import 'package:netflix_plus/repository/movie_repository.dart';

part 'movies_event.dart';
part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MovieRepository repository;

  MoviesBloc({required this.repository}) : super(MoviesInitial());

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
      MovieModel? movies =  await repository.searchMovie(event.searchExpression);
      yield MoviesLoaded(movies!);
    }catch(e){
     yield MoviesError(e.toString());
    }
  }
}