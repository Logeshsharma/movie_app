import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/data/local/database/my_list_database.dart';
import 'package:movie_app/data/remote/web_service.dart';
import 'package:movie_app/screens/home/bloc/movie_list_event.dart';
import 'package:movie_app/screens/home/repo/movie_list_repo.dart';
import 'package:movie_app/screens/home/repo/movie_list_response.dart';

import '../../../animation/animation.dart';
import '../../../constant/constants.dart';
import '../../../routes/route_constants.dart';
import '../../../widget/header_text.dart';
import '../../../widget/horizontal_list_cards.dart';
import '../../../widget/movie_home.dart';
import '../bloc/movie_list_bloc.dart';
import '../bloc/movie_list_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MovieListBloc? movieListBloc;
  List<Movie> _mainMovie = [];
  List<Movie> movie = [];
  List<Movie> topRatedMovie = [];
  List<Movie> upComingMovie = [];
  List<Movie> nowPlayingMovie = [];
  bool isErrorView = false;
  bool isLoadingView = true;
  int currentIndex = 0;
  int _currentMovieIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    MovieListRepository movieListRepository =
        MovieListRepository(webservice: Webservice());
    movieListBloc = MovieListBloc(repository: movieListRepository);
    _initMovieList();
    super.initState();
  }

  _initMovieList() {
    movieListBloc!.add(const MovieListClickEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: MultiBlocListener(
        listeners: [
          BlocListener<MovieListBloc, MovieListState>(
              bloc: movieListBloc,
              listener: (context, state) {
                _movieListBlocListener(context, state);
              }),
        ],
        child: SingleChildScrollView(
          child: _homeScreenView(),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.black,
      //   onTap: (index) {
      //     setState(() {
      //       currentIndex = index;
      //       _bottomBarNavigation(currentIndex);
      //     });
      //   },
      //   unselectedItemColor: Colors.grey,
      //   selectedItemColor: Colors.red,
      //   currentIndex: currentIndex,
      //   iconSize: 26.0,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.home),
      //       activeIcon: Icon(
      //         CupertinoIcons.house_fill,
      //       ),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.checkmark_alt),
      //       activeIcon: Icon(
      //         CupertinoIcons.checkmark_alt,
      //       ),
      //       label: 'My List',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.heart),
      //       label: 'Favorites',
      //       activeIcon: Icon(
      //         CupertinoIcons.heart_solid,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _homeScreenView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _homeScreenTopView(),
        const DelayedDisplay(
            delay: Duration(microseconds: 800),
            child: HeaderText(text: "In Theaters")),
        DelayedDisplay(
          delay: const Duration(microseconds: 800),
          child: HorizontalListViewMovies(
            list: movie,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        const HeaderText(text: "Top Rated"),
        HorizontalListViewMovies(
          list: topRatedMovie,
        ),
        const SizedBox(
          height: 14,
        ),
        const HeaderText(text: "Upcoming"),
        HorizontalListViewMovies(
          list: upComingMovie,
        ),
        const SizedBox(
          height: 14,
        ),
        const HeaderText(text: "Now playing"),
        HorizontalListViewMovies(
          list: nowPlayingMovie,
        )
      ],
    );
  }

  Widget _homeScreenTopView() {
    return _mainMovie.isNotEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height * .56,
            child: Stack(
              children: [
                CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/original${_mainMovie[_currentMovieIndex].backdropPath}",
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * .56),
                Positioned(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .56,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.5),
                        alignment: Alignment.topLeft,
                        child: const SafeArea(
                          child: Text(""),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Colors.black38.withOpacity(1),
                          Colors.black38.withOpacity(1),
                          Colors.black38.withOpacity(.7),
                          Colors.black38.withOpacity(.6),
                          Colors.black38.withOpacity(.4),
                          Colors.black38.withOpacity(.3),
                          Colors.black38.withOpacity(0.5),
                          Colors.black38.withOpacity(0.3),
                          Colors.black38.withOpacity(0.0),
                          Colors.black38.withOpacity(0.0),
                        ])),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  child: DelayedDisplay(
                    delay: const Duration(microseconds: 800),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.4,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.90,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentMovieIndex = index;
                          });
                        },
                      ),
                      carouselController: _carouselController,
                      items: _mainMovie.map((movie) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        boxShadow: kElevationToShadow[8],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DelayedDisplay(
                                        delay:
                                            const Duration(microseconds: 800),
                                        slidingBeginOffset:
                                            const Offset(0.0, -0.01),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://image.tmdb.org/t/p/original${movie.posterPath}",
                                              width: double.infinity,
                                              height: (MediaQuery.of(
                                                              context)
                                                          .size
                                                          .height *
                                                      .38) *
                                                  .6,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Container(
                                                        color: Colors
                                                            .grey.shade900,
                                                      ),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    if (_currentMovieIndex ==
                                        _mainMovie.indexOf(movie))
                                      DelayedDisplay(
                                        delay:
                                            const Duration(microseconds: 800),
                                        slidingBeginOffset:
                                            const Offset(0.0, -0.10),
                                        child: Text(
                                          movie.title ?? "",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    const SizedBox(height: 6),
                                    if (_currentMovieIndex ==
                                        _mainMovie.indexOf(movie))
                                      Expanded(
                                        flex: 1,
                                        child: DelayedDisplay(
                                          delay:
                                              const Duration(microseconds: 900),
                                          slidingBeginOffset:
                                              const Offset(0.0, -0.10),
                                          child: Text(
                                            movie.overview ?? "",
                                            style: normalText.copyWith(
                                                overflow: TextOverflow.clip,
                                                color: Colors.white60,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            movie.isMyList == 1
                                                ? CupertinoIcons.checkmark_alt
                                                : CupertinoIcons.add,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                          onPressed: () {
                                            if (movie.isMyList == 1) {
                                              MyListDatabase.instance.update(
                                                  movie.copyWith(isMyList: 0));
                                            } else if (movie.isMyList == 0) {
                                              MyListDatabase.instance.update(
                                                  movie.copyWith(isMyList: 1));
                                            }
                                          },
                                        ),
                                        const Icon(
                                          CupertinoIcons.play,
                                          color: Colors.white,
                                          size: 35,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          )
        : Text("logesh");
  }

  _bottomBarNavigation(int currentPageIndex) {
    switch (currentPageIndex) {
      case 0:
        return Navigator.pushNamedAndRemoveUntil(context, RouteConstants.rHomeScreen,(route) => false,);
      case 1:
        return Navigator.pushNamedAndRemoveUntil(context, RouteConstants.rMyMovieList,(route) => false,);
      case 2:
        return Navigator.pushNamedAndRemoveUntil(context, RouteConstants.rMyMovieList,(route) => false,);
      default:
        return Navigator.pushNamedAndRemoveUntil(context, RouteConstants.rHomeScreen,(route) => false,);
    }
  }

  _movieListBlocListener(
      BuildContext buildContext, MovieListState movieListState) {
    if (movieListState is MovieListLoading) {
      setState(() {
        isLoadingView = true;
      });
    } else if (movieListState is MovieListError) {
      setState(() {
        isLoadingView = true;
      });
    } else if (movieListState is MovieListSuccess) {
      setState(() {
        isLoadingView = false;
        isErrorView = false;
        if (movieListState.movieListResponse.results != null) {
          if (movieListState.movieListResponse.results!.isNotEmpty) {
            movie = movieListState.movieListResponse.results!;
            topRatedMovie = movieListState.movieListResponse.results!;
            upComingMovie = movieListState.movieListResponse.results!;
            nowPlayingMovie = movieListState.movieListResponse.results!;

            for (var movieElement
                in movieListState.movieListResponse.results!) {
              MyListDatabase.instance.insert(movieElement);
            }

            MyListDatabase.instance.getMovieList().then((value) {
              setState(() {
                _mainMovie = value;
              });
            });
          } else {}
        } else {}
      });
    }
  }
}
