import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider.dart';

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
    final resultsProvider = Provider.of<moviesProvider>(context, listen: false);
    await resultsProvider.fetchByTitleSearch(inputTitle);
    setState(() {
      isSearching = true; // Search is active
    });
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
    return Consumer<moviesProvider>(
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
                    // Use the initialized controller
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
                        // Reset search when input is cleared
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
                  return Container(
                    width: 200,
                    child: Card(
                      color: Color(0x9e1e1515),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: albumList[index].posterPath != null
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w500${albumList[index].posterPath}',
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
                                  onPressed: () {},
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
                          SizedBox(width: 8),
                          Flexible(
                            child: ListTile(
                              title: Text(albumList[index].title ?? 'No Title'),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Text(albumList[index]
                                          .voteAverage
                                          .toString()),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  // Adds spacing between rating and overview
                                  Text(
                                    albumList[index].overview ?? '',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
