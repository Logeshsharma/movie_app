abstract class MovieListEvent {
  const MovieListEvent();
}

class MovieListClickEvent extends MovieListEvent {
  const MovieListClickEvent();

  @override
  List<Object> get props => [];
}
