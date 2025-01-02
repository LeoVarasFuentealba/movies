class Actor {
  final int id;
  final String name;
  final String? profilePath;
  final double? popularity;
  final String? biography;
  final List<String>? knownForMovies;

  Actor({
    required this.id,
    required this.name,
    this.profilePath,
    this.popularity,
    this.biography,
    this.knownForMovies,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'],
      name: map['name'],
      profilePath: map['profile_path'],
      popularity: (map['popularity'] as num?)?.toDouble(),
      biography: map['biography'],
      knownForMovies: (map['known_for'] as List<dynamic>?)
          ?.map((movie) => movie['title'] as String)
          .toList(),
    );
  }
}
