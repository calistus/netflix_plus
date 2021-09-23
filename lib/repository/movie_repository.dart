import 'package:dio/dio.dart';
import 'package:netflix_plus/config/api_config.dart';
import 'package:netflix_plus/model/movie_model.dart';
import 'package:netflix_plus/model/rating_model.dart';

class MovieRepository{

  Future<MovieModel?> searchMovie(String searchExpression) async{
      var response = await Dio().get(APIConfig.baseURL(endpoint: "/SearchMovie")+"/$searchExpression");
      if(response.statusCode == 200){
        return MovieModel.fromJson(response.data);
      }else{
        throw Exception("We encountered an error");
      }
  }

  Future<RatingModel?> fetchMovieRating(String movieID) async{
    var response = await Dio().get(APIConfig.baseURL(endpoint: "/Ratings"));
    if(response.statusCode == 200){
      return RatingModel.fromJson(response.data);
    }else{
      throw Exception("We encountered an error");
    }
  }
}