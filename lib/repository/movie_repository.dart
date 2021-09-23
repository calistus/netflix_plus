import 'package:dio/dio.dart';
import 'package:netflix_plus/config/api_config.dart';
import 'package:netflix_plus/model/movie_model.dart';

class MovieRepository{

  Future<MovieModel?> searchMovie(String searchExpression) async{
      var response = await Dio().get(APIConfig.baseURL()+"/$searchExpression");
      if(response.statusCode == 200){
        return MovieModel.fromJson(response.data);
      }else{
        throw Exception("We encountered an error");
      }
  }
}