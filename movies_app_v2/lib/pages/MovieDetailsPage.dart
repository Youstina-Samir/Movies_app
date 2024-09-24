import 'package:flutter/material.dart';
import 'package:movies_app_v2/ViewModelProvider.dart';
import '../Services/db.dart'; // Assuming this contains your DB logic for saving movies
import '../model/Categories.dart';
import '../model/movie.dart';

class MovieDetailsPage extends StatefulWidget {
  final Results movie; // Your movie model

  MovieDetailsPage({required this.movie});

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  bool isMovieSaved = false;
  final movieProvider = MoviesProvider();

  @override
  void initState() {
    super.initState();
    checkIfSaved(widget.movie);
    fetchGenresAndUpdate();
  }

  Future<void> fetchGenresAndUpdate() async {
    await movieProvider.fetchGenres();
    setState(() {});
  }

  Future<void> checkIfSaved(Results movie) async {
    bool saved =
        await isSaved(movie.id!); // Check if the movie is already saved
    setState(() {
      isMovieSaved = saved;
    });
  }

  String findTheGenre(List<int> movieGenres) {
    String genreString = "";
    var gList = movieProvider.genreList;

    for (int genreId in movieGenres) {
      for (var genre in gList) {
        if (genreId == genre.id) {
          genreString += "${genre.name}  ";
        }
      }
    }

    print(genreString);
    return genreString;
  }

  void saveMovie(Results movie) async {
    if (isMovieSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie.title} is already saved!')),
      );
    } else {
      await insertMovie(movie); // Save movie to DB
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie.title} has been added to favorites!')),
      );
      setState(() {
        isMovieSaved = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Poster
                  Stack(
                    children: [
                      movie.posterPath != null
                          ? Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              height: 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 400,
                              width: double.infinity,
                              color: Colors.grey,
                              child: Center(
                                child: Text(
                                  'No Image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                      // Back button
                      Positioned(
                        top: 30,
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      // Add to favorites button
                      Positioned(
                        top: 8,
                        right: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            saveMovie(movie);
                          },
                          child: Icon(
                            isMovieSaved ? Icons.check : Icons.add,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Color(0x498F7676),
                            padding: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Movie Details
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF000000),
                            Color(0x81390B0B),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.7],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              movie.title ?? 'No Title',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),

                            // Rating
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                SizedBox(width: 5),
                                Text(
                                  movie.voteAverage.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),

                            // Release Date
                            Text(
                              'Release Date: ${movie.releaseDate ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                            ),
                            SizedBox(height: 8),

                            if (movie.genreIds != null)
                              Text(
                                'Genres: ${findTheGenre(movie.genreIds!)} ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                ),
                              ),
                            SizedBox(height: 8),

                            // Overview
                            Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              movie.overview ?? 'No Overview',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
