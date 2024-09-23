class MoviesList {
  int? page;
  List<Results>? results;
  int? totalPages;
  int? totalResults;

  MoviesList({this.page, this.results, this.totalPages, this.totalResults});

  // Factory constructor from JSON
  factory MoviesList.fromJson(Map<String, dynamic> json) {
    return MoviesList(
      page: json['page'],
      results: json['results'] != null
          ? List<Results>.from(
              json['results'].map((v) => Results.fromJson(v)),
            )
          : null,
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = this.totalPages;
    data['total_results'] = this.totalResults;
    return data;
  }
}

class Results {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  Results(
      {this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount});

  // Factory constructor from JSON
  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
      genreIds: List<int>.from(json['genre_ids']),
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      title: json['title'],
      video: json['video'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['release_date'] = this.releaseDate;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adult': (adult ?? false) ? 1 : 0,
      'backdrop_path': backdropPath,
      'genre_ids': genreIds != null ? genreIds!.join(',') : '',
      'original_language': originalLanguage,
      'original_title': originalTitle,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'video': (video ?? false) ? 1 : 0,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }

  factory Results.fromMap(Map<String, dynamic> map) {
    return Results(
      id: map['id'],
      adult: (map['adult'] ?? 0) == 1,
      // Convert integer to boolean
      backdropPath: map['backdrop_path'],
      genreIds: map['genre_ids'] != null && map['genre_ids'].isNotEmpty
          ? (map['genre_ids']
              .split(',')
              .map((id) => int.parse(id))
              .toList()
              .cast<int>()) // Explicitly cast to List<int>
          : [],
      originalLanguage: map['original_language'],
      originalTitle: map['original_title'],
      overview: map['overview'],
      popularity: map['popularity'],
      posterPath: map['poster_path'],
      releaseDate: map['release_date'],
      title: map['title'],
      video: (map['video'] ?? 0) == 1,
      // Convert integer to boolean
      voteAverage: map['vote_average'],
      voteCount: map['vote_count'],
    );
  }
}
