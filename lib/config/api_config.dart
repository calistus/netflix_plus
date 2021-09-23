import 'package:flutter_dotenv/flutter_dotenv.dart';


class APIConfig{

  static baseURL({required endpoint}) => "https://imdb-api.com/en/API/$endpoint/$dotenv.env['IMDB_API_KEY']";
}
