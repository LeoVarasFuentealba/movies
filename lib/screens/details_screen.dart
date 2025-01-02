  import 'package:fade_shimmer/fade_shimmer.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:get/get.dart';
  import 'package:movies/api/api.dart';
  import 'package:movies/api/api_service.dart';
  import 'package:movies/controllers/movies_controller.dart';
  import 'package:movies/models/movie.dart';
  import 'package:movies/models/review.dart';
  import 'package:movies/models/actor.dart';
  import 'package:movies/utils/utils.dart';
  import 'package:movies/screens/actor_details_screen.dart';

  class DetailsScreen extends StatelessWidget {
    const DetailsScreen({
      super.key,
      required this.movie,
    });

    final Movie movie;

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        tooltip: 'Back to home',
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Detail',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                      Tooltip(
                        message: 'Save this movie to your watch list',
                        triggerMode: TooltipTriggerMode.tap,
                        child: IconButton(
                          onPressed: () {
                            Get.put(MoviesController()).addToWatchList(movie);
                          },
                          icon: Obx(
                                () => Get.put(MoviesController()).isInWatchList(movie)
                                ? const Icon(
                              Icons.bookmark,
                              color: Colors.white,
                              size: 33,
                            )
                                : const Icon(
                              Icons.bookmark_outline,
                              color: Colors.white,
                              size: 33,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Movie Image Section
                SizedBox(
                  height: 330,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Image.network(
                          '${Api.imageBaseUrl}${movie.backdropPath}',
                          width: Get.width,
                          height: 250,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return FadeShimmer(
                              width: Get.width,
                              height: 250,
                              highlightColor: const Color(0xff22272f),
                              baseColor: const Color(0xff20252d),
                            );
                          },
                          errorBuilder: (_, __, ___) => const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.broken_image,
                              size: 250,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 30,
                        child: Row(
                          children: [
                            // Poster Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                                width: 110,
                                height: 140,
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, progress) {
                                  if (progress == null) return child;
                                  return const FadeShimmer(
                                    width: 110,
                                    height: 140,
                                    highlightColor: Color(0xff22272f),
                                    baseColor: Color(0xff20252d),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Title and Rating
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/Star.svg'),
                                    const SizedBox(width: 5),
                                    Text(
                                      movie.voteAverage == 0.0
                                          ? 'N/A'
                                          : movie.voteAverage.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFFF8700),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Metadata Section
                Opacity(
                  opacity: .6,
                  child: SizedBox(
                    width: Get.width / 1.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/calender.svg'),
                            const SizedBox(width: 5),
                            Text(
                              movie.releaseDate.split('-')[0],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const Text('|'),
                        Row(
                          children: [
                            SvgPicture.asset('assets/Ticket.svg'),
                            const SizedBox(width: 5),
                            Text(
                              Utils.getGenres(movie),
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tabs Section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TabBar(
                          indicatorWeight: 4,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Color(0xFF3A3F47),
                          tabs: [
                            Tab(text: 'About Movie'),
                            Tab(text: 'Reviews'),
                            Tab(text: 'Cast'),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            children: [
                              // About Movie
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  movie.overview.isNotEmpty
                                      ? movie.overview
                                      : 'No description available.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ),
                              // Reviews
                              FutureBuilder<List<Review>>(
                                future: ApiService.getMovieReviews(movie.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error: ${snapshot.error}',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  final reviews = snapshot.data;
                                  if (reviews == null || reviews.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'No reviews available.',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    itemCount: reviews.length,
                                    itemBuilder: (context, index) {
                                      final review = reviews[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/avatar.svg',
                                              height: 50,
                                              width: 50,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    review.author,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    review.comment,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // Cast (Mostrar actores)
                              FutureBuilder<List<Actor>>(
                                future: ApiService.getCast(movie.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }
                                  final cast = snapshot.data;
                                  if (cast == null || cast.isEmpty) {
                                    return const Center(child: Text('No actors available.'));
                                  }
                                  return ListView.builder(
                                    itemCount: cast.length,
                                    itemBuilder: (context, index) {
                                      final actor = cast[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navegar a la pantalla de detalles del actor
                                            Get.to(() => ActorDetailsScreen(actor: actor));
                                          },
                                          child: Row(
                                            children: [
                                              // Carga la imagen del actor o muestra un ícono si no existe el perfil
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  '${Api.imageBaseUrl}${actor.profilePath ?? ''}', // Usa un valor predeterminado vacío si es null
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50), // Si hay un error, mostramos un ícono
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              // Nombre del actor
                                              Text(
                                                actor.name,
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
