import 'package:movie_app/screens/home/repo/movie_list_response.dart';

abstract class MovieListState {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListEmpty extends MovieListState {}

class MovieListLoading extends MovieListState {}

class MovieListError extends MovieListState {
  final String error;
  const MovieListError({required this.error});

  @override
  List<Object> get props => [error];
}

class MovieListSuccess extends MovieListState {
  final MovieListResponse movieListResponse;

  const MovieListSuccess({required this.movieListResponse});

  @override
  List<Object> get props => [movieListResponse];
}
