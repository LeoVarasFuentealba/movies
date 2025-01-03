import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actor.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';
import 'api_end_points.dart';

class ApiService {
  // Método para obtener las películas mejor calificadas
  static Future<List<Movie>> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      // Realiza una solicitud GET para obtener las películas mejor calificadas.
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body); // Decodifica la respuesta JSON.

      // Selecciona un subconjunto de resultados (de la posición 6 a la 10).
      res['results'].skip(6).take(5).forEach(
            (m) => movies.add(
          Movie.fromMap(m), // Convierte cada elemento en un objeto `Movie`.
        ),
      );
    } catch (e) {
      print("Error fetching top-rated movies: $e"); // Manejo de errores.
    }
    return movies; // Retorna la lista de películas.
  }

  // Método para obtener el reparto de una película específica.
  static Future<List<Actor>> getCast(int movieId) async {
    List<Actor> actors = [];
    try {
      // Realiza una solicitud GET para obtener el reparto de una película.
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${Api.apiKey}&language=en-US'
      ));
      var data = jsonDecode(response.body);

      // Verifica si hay datos en la propiedad 'cast'.
      if (data['cast'] != null) {
        for (var actor in data['cast']) {
          actors.add(Actor.fromMap(actor)); // Agrega cada actor a la lista.
        }
      }
    } catch (e) {
      print("Error fetching cast: $e"); // Manejo de errores.
    }
    return actors;
  }

  // Método para obtener películas personalizadas según una URL específica.
  static Future<List<Movie>> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      // Realiza una solicitud GET utilizando la URL personalizada.
      http.Response response =
      await http.get(Uri.parse('${Api.baseUrl}movie/$url'));
      var res = jsonDecode(response.body);

      // Selecciona los primeros 6 resultados.
      res['results'].take(6).forEach(
            (m) => movies.add(
          Movie.fromMap(m), // Convierte cada resultado en un objeto `Movie`.
        ),
      );
    } catch (e) {
      print("Error fetching custom movies: $e");
    }
    return movies;
  }

  // Método para buscar películas por un término de consulta.
  static Future<List<Movie>> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      // Realiza una solicitud GET para buscar películas que coincidan con el término.
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      var res = jsonDecode(response.body);

      // Convierte cada resultado en un objeto `Movie`.
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

  // Método para obtener reseñas de una película específica.
  static Future<List<Review>> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      // Realiza una solicitud GET para obtener reseñas de una película.
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);

      // Convierte cada reseña en un objeto `Review`.
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

  // Método para obtener una lista de actores populares.
  static Future<List<Actor>> getPopularActors() async {
    List<Actor> actors = [];
    try {
      // Realiza una solicitud GET para obtener actores populares.
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}${ApiEndPoints.popularActors}?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);

      for (var a in res['results']) {
        try {
          // Solicita detalles adicionales de cada actor.
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

  // Método para obtener las películas en las que ha participado un actor.
  static Future<List<Movie>> getMoviesByActor(int actorId) async {
    List<Movie> movies = [];
    try {
      // Realiza una solicitud GET para obtener las películas de un actor.
      final response = await http.get(Uri.parse(
          '${Api.baseUrl}person/$actorId/movie_credits?api_key=${Api.apiKey}&language=en-US'));
      var data = jsonDecode(response.body);

      // Verifica si hay películas en el reparto del actor.
      if (data['cast'] != null && data['cast'].isNotEmpty) {
        for (var movie in data['cast']) {
          movies.add(Movie.fromMap(movie)); // Convierte cada película en un objeto `Movie`.
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
