import 'package:flutter/material.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/api/api_service.dart';
import '../models/movie.dart';
import 'details_screen.dart'; // Importa la pantalla de detalles

class ActorDetailsScreen extends StatelessWidget {
  final Actor actor; // Actor seleccionado cuyos detalles se mostrarán.

  const ActorDetailsScreen({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          actor.name, // Muestra el nombre del actor en la barra superior.
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF242A32), // Fondo oscuro para el AppBar.
        iconTheme: const IconThemeData(color: Colors.white), // Íconos en blanco.
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de perfil del actor (si está disponible).
              if (actor.profilePath != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${actor.profilePath}',
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Nombre del actor.
              Text(
                actor.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              // Biografía del actor (si está disponible).
              if (actor.biography != null && actor.biography!.isNotEmpty)
                Text(
                  actor.biography!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 24),
              // Sección de películas conocidas.
              const Text(
                'Movies',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
              // Lista de películas obtenida mediante un `FutureBuilder`.
              FutureBuilder<List<Movie>>(
                future: ApiService.getMoviesByActor(actor.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No movies available');
                  } else {
                    List<Movie> movies = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navegar a la pantalla de detalles de la película.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(
                                  movie: movies[index], // Pasa la película seleccionada.
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: movies[index].posterPath.isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w92${movies[index].posterPath}',
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Icon(Icons.image, size: 50), // Icono si no hay imagen.
                            title: Text(
                              movies[index].title,
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            subtitle: Text(
                              movies[index].releaseDate ?? 'Unknown Release Date',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
