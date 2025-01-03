import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';

class ActorsController extends GetxController {
  var isLoading = false.obs; // Variable observable que indica si se está cargando información.
  var topRatedActors = <Actor>[].obs; // Lista observable de actores mejor calificados.
  var watchListMovies = <Actor>[].obs; // Lista observable para la lista de seguimiento de actores.

  @override
  void onInit() async {
    super.onInit();
    await fetchTopRatedActors(); // Llama al método para obtener actores mejor calificados al inicializar el controlador.
  }

  // Método para obtener los actores mejor calificados.
  Future<void> fetchTopRatedActors() async {
    isLoading.value = true; // Indica que la información está cargándose.
    try {
      final actors = await ApiService.getPopularActors(); // Llama al servicio API para obtener los actores populares.
      if (actors != null) {
        topRatedActors.value = actors; // Actualiza la lista observable con los datos obtenidos.
      }
    } catch (e) {
      // Muestra un mensaje de error en caso de fallar la solicitud.
      Get.snackbar(
        'Error',
        'Failed to fetch actors: $e',
        snackPosition: SnackPosition.BOTTOM, // Ubicación del snackbar en la pantalla.
        animationDuration: const Duration(milliseconds: 500), // Duración de la animación del snackbar.
        duration: const Duration(seconds: 2), // Duración del snackbar en la pantalla.
      );
    } finally {
      isLoading.value = false; // Indica que la carga ha finalizado.
    }
  }

  // Método para obtener un actor por su ID.
  Actor? getActorById(int id) {
    try {
      return topRatedActors.firstWhere((actor) => actor.id == id); // Busca el actor con el ID especificado en la lista.
    } catch (e) {
      return null; // Retorna null si no se encuentra el actor.
    }
  }

  // Método para verificar si un actor está en la lista de seguimiento.
  bool isInWatchList(Actor actor) {
    return watchListMovies.any((a) => a.id == actor.id); // Devuelve true si el actor está en la lista de seguimiento.
  }

  // Método para agregar o eliminar un actor de la lista de seguimiento.
  void addToWatchList(Actor actor) {
    if (watchListMovies.any((a) => a.id == actor.id)) {
      watchListMovies.remove(actor); // Elimina el actor de la lista si ya está incluido.
      Get.snackbar(
        'Success',
        'Removed from watch list', // Mensaje de éxito al eliminar el actor.
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 500),
      );
    } else {
      watchListMovies.add(actor); // Agrega el actor a la lista de seguimiento.
      Get.snackbar(
        'Success',
        'Added to watch list', // Mensaje de éxito al agregar el actor.
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 500),
      );
    }
  }
}
