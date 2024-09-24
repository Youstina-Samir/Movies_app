import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Categories.dart';
import '../model/movie.dart';

class MoviesService {
  var headers = {
    'accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNTI1YjRkNzBlZDA1YTBiMWVmOWFkNWNiYjY5YmJmNCIsIm5iZiI6MTcyNjk0ODMzNi40ODM5MzgsInN1YiI6IjY2ZWU5ODFhOTJkMzk2ODUzODNhZmYwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.uNiLipXkc2kT_UXRrj2WWoEs7nzdJakeHUAAw3Am-Pk',
  };

  Future<List<Results>> fetchUpcomingMovies() async {
    var response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> resultsList = data['results'];
      return resultsList.map((json) => Results.fromJson(json)).toList();
    }
    return []; // Return an empty list in case of failure
  }

  Future<List<Results>> searchMoviesByTitle(String title) async {
    var response = await http.get(
      Uri.parse("https://api.themoviedb.org/3/search/movie?query=$title"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> resultsList = data['results'];
      return resultsList.map((json) => Results.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Genres>> fetchGenres() async {
    var response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/genre/movie/list?&language=en-US"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> genreList = data['genres'];
      return genreList.map((json) => Genres.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Results>> fetchMoviesByGenre(String genre) async {
    var response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&with_genres=$genre"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> resultsList = data['results'];
      return resultsList.map((json) => Results.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Results>> fetchPopularMovies() async {
    var response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> resultsList = data['results'];
      return resultsList.map((json) => Results.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Results>> fetchTopRatedMovies() async {
    var response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> resultsList = data['results'];
      return resultsList.map((json) => Results.fromJson(json)).toList();
    }
    return [];
  }
}
