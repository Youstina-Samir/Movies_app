import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider.dart';

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
                    // Optional: makes the centered item larger
                    viewportFraction: 0.8,
                    // Controls the width of the carousel items
                    autoPlay: true,
                    // Set to true if you want autoplay
                    aspectRatio: 2.0,
                    // Controls the aspect ratio
                    initialPage: 0,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    final album = moviesProvider.UpcomingMoviesList[index];
                    return Container(
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
                          // Row(
                          // children: [
                          //   Text(album.originalTitle ?? album.title ?? 'No Title Available'),
                          //   SizedBox(width: 8),
                          //   Row(
                          //     children: [
                          //       Icon(Icons.star,color: Colors.yellow,),
                          //       Text(album.voteAverage.toString()),
                          //     ],
                          //   ),
                          // ],
                          // ),
                        ],
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
                      posterPath: album.posterPath,
                      title: album.title,
                      originalTitle: album.originalTitle,
                      voteAverage: album.voteAverage,
                      onPressed: () {
                        // Handle button press
                      },
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
                      posterPath: TopRatedalbum.posterPath,
                      title: TopRatedalbum.title,
                      originalTitle: TopRatedalbum.originalTitle,
                      voteAverage: TopRatedalbum.voteAverage,
                      onPressed: () {
                        // Handle button press
                      },
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

class MovieCard extends StatelessWidget {
  final String? posterPath;
  final String? title;
  final String? originalTitle;
  final double? voteAverage;
  final VoidCallback? onPressed; // For button actions

  MovieCard({
    Key? key,
    required this.posterPath,
    required this.title,
    required this.originalTitle,
    required this.voteAverage,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: posterPath != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w500$posterPath',
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
                    onPressed: onPressed,
                    child: Icon(Icons.add, color: Colors.white),
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
              title: Text(originalTitle ?? title ?? 'No Title Available'),
              subtitle: Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow),
                  Text(voteAverage?.toString() ?? '0'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
