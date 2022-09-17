import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/local/database/my_list_database.dart';

import '../animation/animation.dart';
import '../constant/constants.dart';
import '../screens/home/repo/movie_list_response.dart';

class MoviesPage extends StatefulWidget {
  final List<Movie> movies;

  const MoviesPage({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final CarouselController _carouselController = CarouselController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .56,
      child: Stack(
        children: [
          CachedNetworkImage(
              imageUrl:
                  "https://image.tmdb.org/t/p/original${widget.movies[_current].backdropPath}",
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
                      _current = index;
                    });
                  },
                ),
                carouselController: _carouselController,
                items: widget.movies.map((movie) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                                  delay: const Duration(microseconds: 800),
                                  slidingBeginOffset:
                                      const Offset(0.0, -0.01),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            "https://image.tmdb.org/t/p/original${movie.posterPath}",
                                        width: double.infinity,
                                        height: (MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .38) *
                                            .6,
                                        progressIndicatorBuilder: (context,
                                                url, downloadProgress) =>
                                            Container(
                                              color: Colors.grey.shade900,
                                            ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (_current == widget.movies.indexOf(movie))
                                DelayedDisplay(
                                  delay: const Duration(microseconds: 800),
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
                              if (_current == widget.movies.indexOf(movie))
                                Expanded(
                                  flex: 1,
                                  child: DelayedDisplay(
                                    delay: const Duration(microseconds: 900),
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    icon:  Icon(
                                      movie.isMyList == 1 ? CupertinoIcons.checkmark_alt : CupertinoIcons.add,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    onPressed: () {
                                      if(movie.isMyList == 1){
                                        MyListDatabase.instance.update(movie.copyWith(isMyList: 0));
                                      }else if(movie.isMyList == 0){
                                        MyListDatabase.instance.update(movie.copyWith(isMyList: 1));
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
    );
  }
}
