import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/local/database/my_list_database.dart';

import '../../../animation/animation.dart';
import '../../../routes/route_constants.dart';
import '../../../widget/header_text.dart';
import '../../../widget/horizontal_list_cards.dart';
import '../../home/repo/movie_list_response.dart';

class MyMovieListScreen extends StatefulWidget {
  const MyMovieListScreen({Key? key}) : super(key: key);

  @override
  MyMovieListScreenState createState() => MyMovieListScreenState();
}

class MyMovieListScreenState extends State<MyMovieListScreen> {
  List<Movie> _myMovieListScreen = [];
  int currentIndex = 1;

  @override
  void initState() {
    initMyMovieListScreen();
    super.initState();
  }

  initMyMovieListScreen() {
    MyListDatabase.instance.getMyMovieList().then((value) {
      setState(() {
        _myMovieListScreen.clear();
        _myMovieListScreen = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: _myMovieListView(),
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

  Widget _myMovieListView() {
    return _myMovieListScreen.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DelayedDisplay(
                  delay: Duration(microseconds: 800),
                  child: HeaderText(text: "My List")),
              HorizontalListViewMovies(
                list: _myMovieListScreen,
                navFrom: "myList",
                movieListScreenState: this,
              ),
              const SizedBox(
                height: 14,
              ),
            ],
          )
        : const Text("Logesh");
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
}
