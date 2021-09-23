import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:netflix_plus/bloc/movies_bloc.dart';
import 'package:netflix_plus/model/movie_model.dart';
import 'package:netflix_plus/model/rating_model.dart';
import 'package:netflix_plus/repository/movie_repository.dart';
import 'package:netflix_plus/utilities/ui_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late String searchKey;
  late MoviesBloc moviesBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesBloc(moviesRepository: MovieRepository()),
      child: Builder(builder: (context) {
        moviesBloc = BlocProvider.of<MoviesBloc>(context);
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 140.0,
                backgroundColor: Color(0xff122620),
                floating: true,
                flexibleSpace: ListView(
                  children: <Widget>[
                    const SizedBox(
                      height: 30.0,
                    ),
                    searchBar(context),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 10.0,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        moviesBloc.add(SearchMovie(searchKeyController.text));
                      }
                    },
                    child: const Text("Search"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black87,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                          fontSize: 20,
                        )),
                  ),
                ),
              ),
              BlocConsumer<MoviesBloc, MoviesState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is MoviesLoading) {
                    return SliverToBoxAdapter(
                        child: UIUtils.showCircularLoader("Loading Movies..."));
                  } else if (state is MoviesInitial) {
                    return SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          SizedBox(
                            height: 150,
                          ),
                          Icon(Icons.movie),
                          Text("What movie are you looking for?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20.0)),
                          Text("Search above to Get started")
                        ],
                      ),
                    );
                  } else if (state is MoviesLoaded) {
                    return state.movies.results.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return _buildMovie(
                                  index,
                                  state.movies.results[index],
                                  state.ratings[index]);
                            }, childCount: state.movies.results.length),
                          )
                        : SliverToBoxAdapter(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  height: 100,
                                ),
                                Text("We are heading there"),
                                Text(
                                    "Seems like we don't have this Movie yet. Please check back later")
                              ],
                            ),
                          );
                  } else if (state is MoviesError) {
                    return SliverToBoxAdapter(
                        child: UIUtils.showError(state.message));
                  }
                  return SliverToBoxAdapter(child: Container());
                },
              )
            ],
          ),
        );
      }),
    );
  }

  Container searchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: searchKeyController,
          textAlign: TextAlign.center,
          validator: (input) =>
              input!.isEmpty ? 'Please enter a Movie title' : null,
          onSaved: (input) => searchKey = input!,
          decoration: const InputDecoration(
              hintText: "Type your search here",
              hintStyle: TextStyle(color: Colors.black26),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
        ),
      ),
    );
  }

  Widget _buildMovie(int index, Results movie, RatingModel rating) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: movie.image.isEmpty
                      ? Image.network(
                          "http://enablementnepal.org/wp-content/themes/enablementnepal/img/image-not-found.jpg",
                          width: double.infinity,
                        )
                      : Image.network(
                          movie.image,
                        ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                      onTap: () async {
                        List<Results> currentBookMark =
                            await MovieRepository().getBookMarks();

                        if (currentBookMark.contains(movie)) {
                          UIUtils.showToast("Movie already on Favourite list");
                        } else {
                          currentBookMark.add(movie);
                          MovieRepository().bookMarkMovie(currentBookMark);
                        }
                      },
                      child: bookMarkIcon()),
                ),
                Positioned(
                    bottom: 20.0,
                    right: 10.0,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.white,
                      child: RatingStars(
                        value: double.parse(rating.imDb),
                        onValueChanged: (v) {
                          //
                          setState(() {
                            //value = v;
                          });
                        },
                        starBuilder: (index, color) => Icon(
                          Icons.star,
                          color: color,
                        ),
                        starCount: 10,
                        starSize: 20,
                        valueLabelColor: const Color(0xff9b9b9b),
                        valueLabelTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        valueLabelRadius: 10,
                        maxValue: 10,
                        starSpacing: 2,
                        maxValueVisibility: true,
                        valueLabelVisibility: true,
                        animationDuration: Duration(milliseconds: 1000),
                        valueLabelPadding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 8),
                        valueLabelMargin: const EdgeInsets.only(right: 8),
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: Colors.yellow,
                      ),
                    ))
              ]),
              GestureDetector(
                onTap: () async {},
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        movie.title,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        movie.description,
                        maxLines: 2,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bookMarkIcon() {
    return Icon(
      Icons.favorite_border,
      color: Colors.grey.shade800,
      size: 24.0,
    );
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      UIUtils.showToast(result.toString());
    });
  }
}
