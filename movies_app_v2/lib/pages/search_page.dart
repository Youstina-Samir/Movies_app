import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModelProvider.dart';
import '../db.dart';
import 'MovieDetailsPage.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController searchController = SearchController();
  var genreId; // Default genre ID
  int? selectedIndex; // To store the selected genre index
  bool isSearching = false;

  Future<void> fetchData(String inputTitle) async {
    final resultsProvider =
        Provider.of<moviesViewModel>(context, listen: false);
    await resultsProvider.fetchByTitleSearch(inputTitle);
    setState(() {
      isSearching = true; // Search is active
    });
  }

  void saveMovie(movie) async {
    bool isMovieSaved = await isSaved(movie.id); // Check if the movie is saved
    if (isMovieSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie.title} is already saved!')),
      );
    } else {
      await insertMovie(movie);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${movie.title} has been saved!')),
      );
      setState(() {}); // Refresh UI to update saved status
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<moviesViewModel>(
      builder: (context, moviesProvider, child) {
        var albumList = isSearching
            ? moviesProvider.SearchByTitleList
            : moviesProvider.allGenreMoviesList;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey[900]!),
                    controller: searchController,
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      searchController.openView();
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        fetchData(value); // Trigger fetch when user types
                      } else {
                        setState(() {
                          isSearching = false;
                        });
                      }
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  return [];
                },
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: moviesProvider.genreList.length,
                itemBuilder: (context, index) {
                  final album = moviesProvider.genreList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        searchController.text = "";
                        selectedIndex = index; // Update the selected index
                        genreId = album.id.toString();
                        isSearching = false;
                        moviesProvider.fetchBygenre(genreId);
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 20,
                      child: Card(
                        color: selectedIndex == index
                            ? Color(0xff3a3939) // Change to blue when selected
                            : Color(0xff292828), // Default color for unselected
                        child: Center(
                          child: Text(
                            album.name.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == index
                                  ? Color(
                                      0xffffffff) // Text color for selected card
                                  : Color(
                                      0xffffffff), // Text color for unselected card
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: albumList.length,
                itemBuilder: (context, index) {
                  var movie = albumList[index];

                  return FutureBuilder<bool>(
                    future: isSaved(movie.id!), // Check if movie is saved
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator(); // Show loading while checking
                      }

                      bool isMovieSaved = snapshot.data ?? false;

                      return Container(
                        width: 200,
                        child: Card(
                          color: Color(0x9e1e1515),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MovieDetailsPage(movie: movie),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: movie.posterPath != null
                                          ? Image.network(
                                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                              height: 250,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      )
                                          : Container(
                                              height: 100,
                                        width: 150,
                                        color: Colors.grey,
                                        child: Center(child: Text('No Image')),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: -5,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          saveMovie(movie);
                                        },
                                        child: Icon(
                                          isMovieSaved
                                              ? Icons.check
                                              : Icons.add,
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
                                SizedBox(width: 8),
                                Flexible(
                                  child: ListTile(
                                    title: Text(movie.title ?? 'No Title'),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                            Text(movie.voteAverage.toString()),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          movie.overview ?? '',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
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
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
