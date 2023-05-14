

import 'DatabasaeHelper.dart';

class MovieDetails {
  int? id;
  String? MovieName;
  String? DirectorName;
  String? Poster;
  MovieDetails(this.id, this.MovieName, this.DirectorName, this.Poster);

  MovieDetails.fromMap(
      Map<String, dynamic> map,
      ) {
    id = map['id'];
    MovieName = map['moviename'];
    DirectorName = map['directorName'];
    Poster = map['poster'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseMovieHelperData.columnId: id,
      DatabaseMovieHelperData.columnMovieName: MovieName,
      DatabaseMovieHelperData.columnDirectorName: DirectorName,
      DatabaseMovieHelperData.columnPoster: Poster,
    };
  }
}
