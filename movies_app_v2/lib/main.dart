import 'package:flutter/material.dart';
import 'package:movies_app_v2/pages/fav_page.dart';
import 'package:movies_app_v2/pages/home_page.dart';
import 'package:movies_app_v2/pages/search_page.dart';
import 'package:provider/provider.dart';
import 'ViewModelProvider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => moviesViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          // primary: Color(0xFFBB86FC), // Purple
          secondary: Color(0x98881212), // Teal
        ),
        scaffoldBackgroundColor: Colors.transparent,
        // Make the scaffold background transparent
        useMaterial3: true,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Main text color
          bodyMedium: TextStyle(color: Colors.white70), // Secondary text color
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0; // Default to Home Page (0)

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final resultsProvider =
        Provider.of<moviesViewModel>(context, listen: false);
    await resultsProvider.fetchUpcomingMovies();
    await resultsProvider.fetchGenres();
    await resultsProvider.fetchAiringToday();
    await resultsProvider.fetchTopRated();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              icon: Icon(Icons.home_outlined, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: Colors.white),
              label: 'Search',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.favorite, color: Colors.grey),
              icon: Icon(Icons.favorite_border, color: Colors.white),
              label: 'Favourites',
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF000000),
                Color(0x98390B0B),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: IndexedStack(
            index: currentPageIndex, // Controls which widget to show
            children: [
              HomePage(),
              SearchPage(), // Home page widget
              FavoriteMoviesPage() // Add other pages here
            ],
          ),
        ),
      ),
    );
  }
}
