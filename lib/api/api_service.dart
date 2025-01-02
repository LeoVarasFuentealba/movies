import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';

import 'api_end_points.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
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
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
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
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=YourApiKey&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
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
      return reviews;
    } catch (e) {
      return null;
    }
  }
  static Future<List<Actor>?> getPopularActors() async {
    List<Actor> actors = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.popularActors}?api_key=${Api.apiKey}&language=en-US&page=1'));

      var res = jsonDecode(response.body);

      // Recorrer los actores y hacer una solicitud adicional para obtener más detalles de cada uno
      for (var a in res['results']) {
        // Obtener detalles adicionales del actor, incluida la biografía, usando el endpoint de actor
        http.Response actorDetailsResponse = await http.get(Uri.parse(
            '${Api.baseUrl}person/${a['id']}?api_key=${Api.apiKey}&language=en-US'));

        var actorDetails = jsonDecode(actorDetailsResponse.body);

        // Crear el objeto Actor con la información obtenida
        actors.add(
          Actor(
            id: a['id'],
            name: a['name'],
            profilePath: a['profile_path'],
            popularity: a['popularity'],
            biography: actorDetails['biography'],
          ),
        );
      }

      return actors;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>> getMoviesByActor(int actorId) async {
    List<Movie> movies = [];
    try {
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$actorId/movie_credits?api_key=${Api.apiKey}&language=en-US'));
      var data = jsonDecode(response.body);

      // Imprimir la respuesta para depuración
      print('Response data: $data');

      // Asegúrate de que 'cast' exista y tenga datos
      if (data['cast'] != null && data['cast'].isNotEmpty) {
        for (var movie in data['cast']) {
          movies.add(Movie.fromMap(movie)); // Usamos el modelo Movie para mapear la respuesta
        }
      } else {
        print('No movies found for this actor');
      }
    } catch (e) {
      print("Error fetching movies: $e");
      return [];  // Retornamos una lista vacía en caso de error
    }
    return movies;
  }
}
