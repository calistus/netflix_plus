import 'package:flutter_dotenv/flutter_dotenv.dart';


class APIConfig{

  static baseURL() => "https://imdb-api.com/en/API/SearchMovie/$dotenv.env['IMDB_API_KEY']";
}
