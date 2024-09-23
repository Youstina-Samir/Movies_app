import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app_v2/model/movie.dart';
import 'dart:convert';
import 'model/Categories.dart'; // For JSON decoding

class moviesProvider with ChangeNotifier {
  List<Results> albums1 = [];
  List<Results> get UpcomingMoviesList => albums1;

  List<Results> titleAlbums = [];
  List<Results> get SearchByTitleList => titleAlbums;

  List<Genres> genreAlbum = [];
  List<Genres> get genreList => genreAlbum;

  List<Results> allGenreMovies = [];
  List<Results> get allGenreMoviesList => allGenreMovies;

  List<Results> popularAlbum = [];
  List<Results> get popularList => popularAlbum;

  List<Results> TopRatedAlbum = [];
  List<Results> get TopRatedList => TopRatedAlbum;
  var headers = {
    'accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNTI1YjRkNzBlZDA1YTBiMWVmOWFkNWNiYjY5YmJmNCIsIm5iZiI6MTcyNjk0ODMzNi40ODM5MzgsInN1YiI6IjY2ZWU5ODFhOTJkMzk2ODUzODNhZmYwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uNiLipXkc2kT_UXRrj2WWoEs7nzdJakeHUAAw3Am-Pk',
  };

  Future<void> fetchUpcomingMovies() async {
    // print('fetch');

    var upcomingMovieResponse = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1"),
      headers: headers,
    );
    //   print('code: ${upcomingMovieResponse.statusCode}');
    if (upcomingMovieResponse.statusCode == 200) {
      // Decode the upcomingMovieResponse body as a map
      Map<String, dynamic> data = jsonDecode(upcomingMovieResponse.body);
      // Access the results list from the map
      List<dynamic> upcomingMoviesList = data['results'];
      albums1 =
          upcomingMoviesList.map((json) => Results.fromJson(json)).toList();
      //  print('uocoming movies fetched');
    } else {
      //  print('Failed to fetch movies: ${upcomingMovieResponse.reasonPhrase}');
    }

    notifyListeners();
  }

  Future<void> fetchByTitleSearch(String title) async {
    var SearchByTitleResponse = await http.get(
      Uri.parse("https://api.themoviedb.org/3/search/movie?query=${title}"),
      headers: headers,
    );

    print('code: ${SearchByTitleResponse.statusCode}');
    if (SearchByTitleResponse.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(SearchByTitleResponse.body);
      // Access the results list from the map
      List<dynamic> SearchByTitleList = data['results'];
      titleAlbums =
          SearchByTitleList.map((json) => Results.fromJson(json)).toList();
      print('title movies fetched');
      print(SearchByTitleResponse.body.toString());
    } else {
      print('Failed to fetch movies: ${SearchByTitleResponse.reasonPhrase}');
    }

    notifyListeners();
  }

  Future<void> fetchGenres() async {
    var GenreResponse = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/genre/movie/list?&language=en-US"),
      headers: headers,
    );
    // print('code: ${GenreResponse.statusCode}');
    if (GenreResponse.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(GenreResponse.body);
      List<dynamic> genreList = data['genres'];
      genreAlbum = genreList.map((json) => Genres.fromJson(json)).toList();
      // print('genre');
      // print(GenreResponse.body.toString());
    } else {
      //print('Failed to fetch genre: ${GenreResponse.reasonPhrase}');
    }
    notifyListeners();
  }

  Future<void> fetchBygenre(String genre) async {
    var allGenreListResponse = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_genres=${genre}"),
      headers: headers,
    );

    print('code: ${allGenreListResponse.statusCode}');
    if (allGenreListResponse.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(allGenreListResponse.body);
      // Access the results list from the map
      List<dynamic> allGenreMoviesList = data['results'];
      allGenreMovies =
          allGenreMoviesList.map((json) => Results.fromJson(json)).toList();
      print('all movies of genre fetched');
      print(allGenreListResponse.body.toString());
    } else {
      print('Failed to fetch movies: ${allGenreListResponse.reasonPhrase}');
    }

    notifyListeners();
  }

  Future<void> fetchAiringToday() async {
    var popularRespnse = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1"),
      headers: headers,
    );
    // print('code: ${GenreResponse.statusCode}');
    if (popularRespnse.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(popularRespnse.body);
      List<dynamic> popularList = data['results'];
      popularAlbum = popularList.map((json) => Results.fromJson(json)).toList();
      print('popular');
      print(popularRespnse.body.toString());
    } else {
      //print('Failed to fetch genre: ${GenreResponse.reasonPhrase}');
    }
    notifyListeners();
  }

  Future<void> fetchTopRated() async {
    var TopratedRespnse = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1"),
      headers: headers,
    );
    // print('code: ${GenreResponse.statusCode}');
    if (TopratedRespnse.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(TopratedRespnse.body);
      List<dynamic> TopRatedList = data['results'];
      TopRatedAlbum =
          TopRatedList.map((json) => Results.fromJson(json)).toList();
      print('top rated');
      print(TopratedRespnse.body.toString());
    } else {
      //print('Failed to fetch genre: ${GenreResponse.reasonPhrase}');
    }
    notifyListeners();
  }
}
