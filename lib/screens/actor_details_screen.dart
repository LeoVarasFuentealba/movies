import 'package:flutter/material.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/api/api_service.dart';

import '../models/movie.dart';

class ActorDetailsScreen extends StatelessWidget {
  final Actor actor;

  const ActorDetailsScreen({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(actor.name),
        backgroundColor: const Color(0xFF242A32),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                actor.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              if (actor.biography != null && actor.biography!.isNotEmpty)
                Text(
                  actor.biography!,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 24),
              if (actor.knownForMovies != null && actor.knownForMovies!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Known For',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<List<Movie>>(
                      future: ApiService.getMoviesByActor(actor.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No movies available');
                        } else {
                          List<Movie> movies = snapshot.data!;
                          return SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movies.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      if (movies[index].posterPath.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      else
                                        const Icon(Icons.image, size: 100),
                                      const SizedBox(height: 8),
                                      Text(
                                        movies[index].title,
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
