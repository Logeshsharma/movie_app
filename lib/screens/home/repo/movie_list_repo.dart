import 'package:movie_app/screens/home/repo/movie_list_response.dart';

import '../../../data/remote/web_constants.dart';
import '../../../data/remote/web_service.dart';

class MovieListRepository {
  final Webservice webservice;
  late dynamic returnResponse;

  MovieListRepository({required this.webservice});

  Future<dynamic> getMovieList() async {
    final response = await webservice.getFromService(WebConstants.actionMovieList);
    return MovieListResponse.fromJson(response);
  }
}
