
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screens/home/view/home_screen.dart';
import 'package:movie_app/screens/my_movie_list/view/my_movie_list_screen.dart';


class Common extends StatefulWidget {
  const Common({Key? key}) : super(key: key);

  @override
  _CommonState createState() => _CommonState();
}

class _CommonState extends State<Common> {

  Widget body = const HomeScreen();
  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _bottomBarNavigation(currentIndex);
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.red,
        currentIndex: currentIndex,
        iconSize: 26.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            activeIcon: Icon(
              CupertinoIcons.house_fill,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.checkmark_alt),
            activeIcon: Icon(
              CupertinoIcons.checkmark_alt,
            ),
            label: 'My List',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            label: 'Favorites',
            activeIcon: Icon(
              CupertinoIcons.heart_solid,
            ),
          ),
        ],
      ),
    );

  }

  _bottomBarNavigation(int currentPageIndex) {
    setState(() {
      switch (currentPageIndex) {
        case 0:
             body = const HomeScreen();
             break;
        case 1:
          body = const MyMovieListScreen();
            break;
        case 2:
          body = const MyMovieListScreen();
            break;
        default:
          body = const HomeScreen();
      }
    });

  }
}
