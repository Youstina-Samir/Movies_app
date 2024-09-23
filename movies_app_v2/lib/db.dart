import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:movies_app_v2/model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> initializeDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  return openDatabase(
    join(await getDatabasesPath(), 'favList.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE favList('
        'id INTEGER PRIMARY KEY, '
        'adult INTEGER, '
        'backdrop_path TEXT, '
        'genre_ids TEXT, ' // Could store as a comma-separated string
        'original_language TEXT, '
        'original_title TEXT, '
        'overview TEXT, '
        'popularity REAL, '
        'poster_path TEXT, '
        'release_date TEXT, '
        'title TEXT, '
        'video INTEGER, '
        'vote_average REAL, '
        'vote_count INTEGER)',
      );
    },
    version: 1,
  );
}

// Insert movie function (now globally accessible)
Future<void> insertMovie(Results movie) async {
  final Database db = await initializeDB();
  await db.insert(
    'favList',
    movie.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid duplicates
  );
}

Future<void> deleteMovie(int id) async {
  final db = await initializeDB();
  await db.delete('favList', where: 'id = ?', whereArgs: [id]);
}

Future<List<Results>> getFavoriteMovies() async {
  final Database db = await initializeDB();
  final List<Map<String, dynamic>> maps = await db.query('favList');
  return List.generate(maps.length, (i) {
    return Results.fromMap(maps[i]);
  });
}

Future<bool> isSaved(int movieId) async {
  final Database db = await initializeDB();
  final List<Map<String, dynamic>> maps = await db.query(
    'favList',
    where: 'id = ?',
    whereArgs: [movieId],
  );
  return maps.isNotEmpty;
}
