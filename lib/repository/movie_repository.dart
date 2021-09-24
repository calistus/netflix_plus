import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:netflix_plus/config/api_config.dart';
import 'package:netflix_plus/model/movie_model.dart';
import 'package:netflix_plus/model/rating_model.dart';
import 'package:netflix_plus/utilities/ui_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieRepository{

  Future<MovieModel?> searchMovie(String searchExpression) async{
    Dio dio = Dio();
      var response = await dio.get(APIConfig.baseURL(endpoint: "/SearchMovie")+"/$searchExpression");
      if(response.statusCode == 200){
        return response.data['errorMessage'].isEmpty? MovieModel.fromJson(response.data): throw Exception(response.data['errorMessage']);
      } else{
        throw Exception("We encountered an error");
      }
  }

  Future<RatingModel?> fetchMovieRating(String movieID) async{
    Dio dio = Dio();
    var response = await dio.get(APIConfig.baseURL(endpoint: "/Ratings")+"/$movieID");
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
    UIUtils.showToast("Added to Favourite");
  }

  Future<List<Results>> getBookMarks() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookMarks = prefs.getStringList("bookmarks")??[];

    return bookMarks.map((encondedJSon) => Results.fromJson(jsonDecode(encondedJSon))).toList();
  }

  Future<void> hideMovie(List<Results> updatedhiden) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encondedJsonOfMovies = [];
    for (var movie in updatedhiden) {
      encondedJsonOfMovies.add(jsonEncode(movie.toJson()));
    }
    await prefs.setStringList("hidden", encondedJsonOfMovies);
    UIUtils.showToast("Movie Hidden");
  }

  Future<List<Results>> getHiddenMovies() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> hiddenList = prefs.getStringList("hidden")??[];

    return hiddenList.map((encondedJSon) => Results.fromJson(jsonDecode(encondedJSon))).toList();
  }
}