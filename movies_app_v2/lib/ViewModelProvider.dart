import 'package:flutter/foundation.dart';
import 'Services/MoviesApiService.dart';
import 'model/movie.dart';
import 'model/Categories.dart';

class MoviesProvider with ChangeNotifier {
  final MoviesService _moviesService = MoviesService();

  List<Results> albums1 = [];

  List<Results> get upcomingMoviesList => albums1;

  List<Results> titleAlbums = [];

  List<Results> get searchByTitleList => titleAlbums;

  List<Genres> genreAlbum = [];
  List<Genres> get genreList => genreAlbum;

  List<Results> allGenreMovies = [];
  List<Results> get allGenreMoviesList => allGenreMovies;

  List<Results> popularAlbum = [];
  List<Results> get popularList => popularAlbum;

  List<Results> topRatedAlbum = [];

  List<Results> get topRatedList => topRatedAlbum;

  Future<void> fetchUpcomingMovies() async {
    albums1 = await _moviesService.fetchUpcomingMovies();
    notifyListeners();
  }

  Future<void> fetchByTitleSearch(String title) async {
    titleAlbums = await _moviesService.searchMoviesByTitle(title);
    notifyListeners();
  }

  Future<void> fetchGenres() async {
    genreAlbum = await _moviesService.fetchGenres();
    notifyListeners();
  }

  Future<void> fetchByGenre(String genre) async {
    allGenreMovies = await _moviesService.fetchMoviesByGenre(genre);
    notifyListeners();
  }

  Future<void> fetchPopularMovies() async {
    popularAlbum = await _moviesService.fetchPopularMovies();
    notifyListeners();
  }

  Future<void> fetchTopRatedMovies() async {
    topRatedAlbum = await _moviesService.fetchTopRatedMovies();
    notifyListeners();
  }
}
