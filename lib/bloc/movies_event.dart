part of 'movies_bloc.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();
}

class SearchMovie extends MoviesEvent{
  final String searchExpression;

  const SearchMovie(this.searchExpression);
  @override
  List<Object?> get props => [];
}

class InitApp extends MoviesEvent{

  const InitApp();
  @override
  List<Object?> get props => [];
}