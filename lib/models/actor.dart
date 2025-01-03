class Actor {
  final int id; // Identificador único del actor.
  final String name; // Nombre del actor.
  final String? profilePath; // Ruta del perfil del actor (opcional).
  final double? popularity; // Popularidad del actor (opcional).
  final String? biography; // Biografía del actor (opcional).
  final List<String>? knownForMovies; // Lista de películas conocidas del actor (opcional).

  // Constructor para inicializar los atributos del actor.
  Actor({
    required this.id,
    required this.name,
    this.profilePath,
    this.popularity,
    this.biography,
    this.knownForMovies,
  });

  // Método de fábrica para crear un objeto `Actor` desde un mapa.
  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'], // Asigna el id desde el mapa.
      name: map['name'], // Asigna el nombre desde el mapa.
      profilePath: map['profile_path'], // Asigna la ruta del perfil desde el mapa.
      popularity: (map['popularity'] as num?)?.toDouble(), // Asigna la popularidad como un número flotante, si existe.
      biography: map['biography'], // Asigna la biografía desde el mapa.
      knownForMovies: (map['known_for'] as List<dynamic>?)
          ?.map((movie) => movie['title'] as String) // Extrae los títulos de las películas conocidas del actor.
          .toList(),
    );
  }
}
