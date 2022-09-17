import 'package:flutter/material.dart';
import 'package:movie_app/screens/home/repo/movie_list_response.dart';

import '../screens/my_movie_list/view/my_movie_list_screen.dart';
import 'movie_card.dart';

class HorizontalListViewMovies extends StatefulWidget {
  final List<Movie> list;
  final Color? color;
  final String? navFrom;
  final MyMovieListScreenState? movieListScreenState;

  const HorizontalListViewMovies(
      {Key? key,
      required this.list,
      this.color,
      this.navFrom,
      this.movieListScreenState})
      : super(key: key);

  @override
  _HorizontalListViewMoviesState createState() =>
      _HorizontalListViewMoviesState();
}

class _HorizontalListViewMoviesState extends State<HorizontalListViewMovies> {
  @override
  Widget build(BuildContext context) {
    return widget.navFrom == "myList"
        ? GridView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 350),
            children: [
              for (var i = 0; i < widget.list.length; i++)
                MovieCard(
                    id: widget.list[i].id ?? -1,
                    name: widget.list[i].title ?? "",
                    poster:
                        "https://image.tmdb.org/t/p/original${widget.list[i].posterPath}",
                    color: widget.color == null ? Colors.white : widget.color!,
                    date: widget.list[i].releaseDate ?? "",
                    onTap: () {},
                    isRemove: true)
            ],
          )
        : SizedBox(
            height: 310,
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 7),
                for (var i = 0; i < widget.list.length; i++)
                  MovieCard(
                      id: widget.list[i].id ?? -1,
                      name: widget.list[i].title ?? "",
                      poster:
                          "https://image.tmdb.org/t/p/original${widget.list[i].posterPath}",
                      color:
                          widget.color == null ? Colors.white : widget.color!,
                      date: widget.list[i].releaseDate ?? "",
                      onTap: () {},
                      isRemove: false)
              ],
            ));
  }
}
