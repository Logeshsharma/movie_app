import 'package:flutter/material.dart';
import 'package:movie_app/routes/route_constants.dart';
import 'package:movie_app/screens/common/common.dart';
import 'package:movie_app/screens/home/view/home_screen.dart';
import 'package:movie_app/screens/my_movie_list/view/my_movie_list_screen.dart';

import '../screens/splash/view/splash_screen.dart';

class GeneratedRoutes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    String routeName = routeSettings.name.toString();
    debugPrint("Generated route $args");
    debugPrint("route name  $routeName");

    switch (routeName) {
      case RouteConstants.rSplashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case RouteConstants.rCommon:
        return MaterialPageRoute(builder: (context) => const Common());

      case RouteConstants.rHomeScreen:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

      case RouteConstants.rMyMovieList:
        return MaterialPageRoute(builder: (context) => const MyMovieListScreen());

      default:
        return _routeNotFound(sRouteName: " - " + routeName);
    }
  }

  static Route<dynamic> _routeNotFound({String sRouteName = ""}) {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: Text("Page not found!" + sRouteName),
        ),
      );
    });
  }
}
