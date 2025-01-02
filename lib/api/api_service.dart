import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';
import 'api_end_points.dart';

class ApiService {
  static Future<List<Movie>> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
    } catch (e) {
      // Opcional: Registrar el error para depuración
      print("Error fetching top-rated movies: $e");
    }
    return movies; // Retorna la lista (vacía en caso de error)
  }

  static Future<List<Actor>> getCast(int movieId) async {
    List<Actor> actors = [];
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${Api.apiKey}&language=en-US'
      ));
      var data = jsonDecode(response.body);

      // Verifica si 'cast' contiene datos
      if (data['cast'] != null) {
        for (var actor in data['cast']) {
          actors.add(Actor.fromMap(actor));
        }
      }
    } catch (e) {
      print("Error fetching cast: $e");
    }
    return actors;
  }


  static Future<List<Movie>> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      http.Response response =
      await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
    } catch (e) {
      print("Error fetching custom movies: $e");
    }
    return movies;
  }

  static Future<List<Movie>> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
            (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
    } catch (e) {
      print("Error searching movies: $e");
    }
    return movies;
  }

  static Future<List<Review>> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
            (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
    } catch (e) {
      print("Error fetching reviews: $e");
    }
    return reviews;
  }

  static Future<List<Actor>> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.popularActors}?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);

      for (var a in res['results']) {
        try {
          http.Response actorDetailsResponse = await http.get(Uri.parse(
              '${Api.baseUrl}person/${a['id']}?api_key=${Api.apiKey}&language=en-US'));
          var actorDetails = jsonDecode(actorDetailsResponse.body);

          actors.add(
            Actor(
              id: a['id'],
              name: a['name'],
              profilePath: a['profile_path'],
              popularity: a['popularity'],
              biography: actorDetails['biography'],
            ),
          );
        } catch (actorError) {
          print("Error fetching details for actor ${a['id']}: $actorError");
        }
      }
    } catch (e) {
      print("Error fetching popular actors: $e");
    }
    return actors;
  }

  static Future<List<Movie>> getMoviesByActor(int actorId) async {
    List<Movie> movies = [];
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$actorId/movie_credits?api_key=${Api.apiKey}&language=en-US'));
      var data = jsonDecode(response.body);

      if (data['cast'] != null && data['cast'].isNotEmpty) {
        for (var movie in data['cast']) {
          movies.add(Movie.fromMap(movie));
        }
      } else {
        print('No movies found for this actor');
      }
    } catch (e) {
      print("Error fetching movies by actor: $e");
    }
    return movies;
  }
}
