part of 'movies_bloc.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();
}

class MoviesInitial extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesLoading extends MoviesState {
  @override
  List<Object> get props => [];
}

class MoviesLoaded extends MoviesState {
  final MovieModel movies;

  const MoviesLoaded(this.movies);
  @override
  List<Object> get props => [movies];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);
  @override
  List<Object> get props => [message];
}