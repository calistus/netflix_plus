class RatingModel {
  RatingModel({
    required this.imDbId,
    required this.title,
    required this.fullTitle,
    required this.type,
    required this.year,
    required this.imDb,
    required this.metacritic,
    required this.theMovieDb,
    required this.rottenTomatoes,
    required this.tVCom,
    required this.filmAffinity,
    required this.errorMessage,
  });
  late final String imDbId;
  late final String title;
  late final String fullTitle;
  late final String type;
  late final String year;
  late final String imDb;
  late final String metacritic;
  late final String theMovieDb;
  late final String rottenTomatoes;
  late final String tVCom;
  late final String filmAffinity;
  late final String errorMessage;

  RatingModel.fromJson(Map<String, dynamic> json){
    imDbId = json['imDbId'];
    title = json['title'];
    fullTitle = json['fullTitle'];
    type = json['type'];
    year = json['year'];
    imDb = json['imDb'];
    metacritic = json['metacritic'];
    theMovieDb = json['theMovieDb'];
    rottenTomatoes = json['rottenTomatoes'];
    tVCom = json['tV_com'];
    filmAffinity = json['filmAffinity'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['imDbId'] = imDbId;
    _data['title'] = title;
    _data['fullTitle'] = fullTitle;
    _data['type'] = type;
    _data['year'] = year;
    _data['imDb'] = imDb;
    _data['metacritic'] = metacritic;
    _data['theMovieDb'] = theMovieDb;
    _data['rottenTomatoes'] = rottenTomatoes;
    _data['tV_com'] = tVCom;
    _data['filmAffinity'] = filmAffinity;
    _data['errorMessage'] = errorMessage;
    return _data;
  }
}