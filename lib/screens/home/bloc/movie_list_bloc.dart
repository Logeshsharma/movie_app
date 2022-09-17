import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screens/home/repo/movie_list_response.dart';

import '../repo/movie_list_repo.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final MovieListRepository repository;

  MovieListBloc({required this.repository}) : super(MovieListEmpty()) {
    on<MovieListEvent>(_getMovieList);
  }

  MovieListState get initialState => MovieListEmpty();

  _getMovieList(MovieListEvent movieListEvent,
      Emitter<MovieListState> movieListState) async {
    emit(MovieListLoading());
    try {
      final response = await repository.getMovieList();
      if (response is MovieListResponse) {
        emit(MovieListSuccess(movieListResponse: response));
      } else {
        emit(const MovieListError(error: 'something went wrong'));
      }
    } on MovieListError catch (e) {
      emit(MovieListError(error: e.toString()));
    } catch (e) {
      emit(const MovieListError(error: 'something went wrong'));
    }
  }
}
