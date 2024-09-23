import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_v2/db.dart';
import 'package:provider/provider.dart';
import '../Provider.dart';
import '../model/movie.dart';
import 'MovieDetailsPage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<moviesProvider>(
      builder: (context, moviesProvider, child) {
        if (moviesProvider.UpcomingMoviesList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Upcoming Movies",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,

                // width: 400,
                child: CarouselSlider.builder(
                  itemCount: moviesProvider.UpcomingMoviesList.length,
                  options: CarouselOptions(
                    height: 400,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                    autoPlay: true,
                    aspectRatio: 2.0,
                    initialPage: 0,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    final album = moviesProvider.UpcomingMoviesList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsPage(movie: album),
                          ),
                        );
                      },
                      child: Container(
                        // width: 200,
                        child: Stack(
                          children: [
                            album.posterPath != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${album.posterPath}',
                                    width: MediaQuery.of(context)
                                        .size
                                        .width, // Fill screen width
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey,
                                    child: Center(child: Text('No Image')),
                                  ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Popular Today",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 360,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: moviesProvider.popularList.length,
                  itemBuilder: (context, index) {
                    final album = moviesProvider.popularList[index];
                    return MovieCard(
                      movie: album,
                      posterPath: album.posterPath,
                      title: album.title,
                      originalTitle: album.originalTitle,
                      voteAverage: album.voteAverage,
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Top Rated Movies",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                height: 360,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: moviesProvider.TopRatedList.length,
                  itemBuilder: (context, index) {
                    final TopRatedalbum = moviesProvider.TopRatedList[index];
                    return MovieCard(
                      movie: TopRatedalbum,
                      posterPath: TopRatedalbum.posterPath,
                      title: TopRatedalbum.title,
                      originalTitle: TopRatedalbum.originalTitle,
                      voteAverage: TopRatedalbum.voteAverage,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MovieCard extends StatefulWidget {
  final Results movie;
  final String? posterPath;
  final String? title;
  final String? originalTitle;
  final double? voteAverage;

  MovieCard({
    Key? key,
    required this.movie,
    required this.posterPath,
    required this.title,
    required this.originalTitle,
    required this.voteAverage,
  }) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool isMovieSaved = false;

  @override
  void initState() {
    super.initState();
    checkIfSaved();
  }

  Future<void> checkIfSaved() async {
    bool saved = await isSaved(widget.movie.id!);
    setState(() {
      isMovieSaved = saved;
    });
  }

  void saveMovie(int movieId) async {
    if (isMovieSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.movie.title} is already saved!')),
      );
    } else {
      await insertMovie(widget.movie);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.movie.title} has been saved!')),
      );
      setState(() {
        isMovieSaved = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIfSaved();
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(movie: widget.movie),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: widget.posterPath != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w500${widget.posterPath}',
                            height: 250,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 150,
                            width: 200,
                            color: Colors.grey,
                            child: Center(child: Text('No Image')),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    right: -5,
                    child: ElevatedButton(
                      onPressed: () {
                        saveMovie(widget.movie.id!);
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
              SizedBox(height: 8),
              ListTile(
                title: Text(widget.originalTitle ??
                    widget.title ??
                    'No Title Available'),
                subtitle: Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    Text(widget.voteAverage?.toString() ?? '0'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
