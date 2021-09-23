import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:netflix_plus/config/api_config.dart';
import 'package:netflix_plus/model/movie_model.dart';
import 'package:netflix_plus/model/rating_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieRepository{

  Future<MovieModel?> searchMovie(String searchExpression) async{
    Dio dio = Dio();
      var response = await dio.get(APIConfig.baseURL(endpoint: "/SearchMovie")+"/$searchExpression");
      print(response.data);
      if(response.statusCode == 200){
        return MovieModel.fromJson(response.data);
      }else{
        throw Exception("We encountered an error");
      }
  }

  Future<RatingModel?> fetchMovieRating(String movieID) async{
    Dio dio = Dio();
    var response = await dio.get(APIConfig.baseURL(endpoint: "/Ratings")+"/$movieID");
    print(response.data);
    if(response.statusCode == 200){
      return RatingModel.fromJson(response.data);
    }else{
      throw Exception("We encountered an error");
    }
  }

  Future<void> bookMarkMovie(List<Results> updatedBookMarks) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encondedJsonOfMovies = [];
    for (var movie in updatedBookMarks) {
      encondedJsonOfMovies.add(jsonEncode(movie.toJson()));
    }
    await prefs.setStringList("bookmarks", encondedJsonOfMovies);
  }

  Future<List<Results>> getBookMarks() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookMarks = prefs.getStringList("bookmarks")??[];

    return bookMarks.map((encondedJSon) => Results.fromJson(jsonDecode(encondedJSon))).toList();
  }
}