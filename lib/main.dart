import 'package:flutter/material.dart';
import 'package:movie_app/routes/generated_routes.dart';
import 'package:movie_app/routes/route_constants.dart';
import 'package:movie_app/widget/bottom_nav_bar.dart';

void main() {
  runApp(const MovieApp());
}


class MovieApp extends StatefulWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: ThemeData(
      //     fontFamily: 'SFUI'),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteConstants.rSplashScreen,
      onGenerateRoute: GeneratedRoutes.generateRoute,
      home: BottomNavBar(),
    );
  }
}
