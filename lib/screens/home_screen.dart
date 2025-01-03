import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/actors_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/models/actor.dart';
import 'package:movies/screens/actor_details_screen.dart';
import 'package:movies/widgets/search_box.dart';
import 'package:movies/widgets/tab_builder.dart';
import 'package:movies/widgets/top_rated_actor_item.dart';

class HomeScreen extends StatelessWidget {
  // Definimos el controlador para actores y la búsqueda
  HomeScreen({super.key});

  final ActorsController controller = Get.put(ActorsController());
  final SearchController1 searchController = Get.put(SearchController1());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            const Text(
              'Who is your favorite actor?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            // Cuadro de búsqueda para buscar actores
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text;
                Get.find<SearchController1>().searchController.text = '';
                Get.find<SearchController1>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 34),
            // Mostrar los actores más valorados
            Obx(
                  () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Rated Actors',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300, // Altura fija para ListView horizontal
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(), // Efecto de rebote
                      scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                      itemCount: controller.topRatedActors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 24),
                      itemBuilder: (_, index) {
                        final actor = controller.topRatedActors[index];
                        return GestureDetector(
                          onTap: () {
                            // Navegar a la pantalla de detalles del actor
                            Get.to(() => ActorDetailsScreen(actor: actor));
                          },
                          child: TopRatedActorItem(
                            actor: actor,
                            index: index + 1,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 34),
            // Sección de pestañas
            DefaultTabController(
              length: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TabBar(
                    indicatorWeight: 3,
                    indicatorColor: Color(0xFF3A3F47),
                    labelStyle: TextStyle(fontSize: 11.0),
                    tabs: [
                      Tab(text: 'Now playing'),
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Top rated'),
                      Tab(text: 'Popular'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        // Pestaña de películas en emisión
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'now_playing?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        // Pestaña de películas próximas
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'upcoming?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        // Pestaña de películas más valoradas
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'top_rated?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                        // Pestaña de películas populares
                        TabBuilder(
                          future: ApiService.getCustomMovies(
                            'popular?api_key=${Api.apiKey}&language=en-US&page=1',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
