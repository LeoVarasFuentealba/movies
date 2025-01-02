import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actor.dart';

class ActorsController extends GetxController {
  var isLoading = false.obs;
  var topRatedActors = <Actor>[].obs;
  var watchListMovies = <Actor>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchTopRatedActors();
  }

  Future<void> fetchTopRatedActors() async {
    isLoading.value = true;
    try {
      final actors = await ApiService.getPopularActors();
      if (actors != null) {
        topRatedActors.value = actors;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch actors: $e',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  Actor? getActorById(int id) {
    try {
      return topRatedActors.firstWhere((actor) => actor.id == id);
    } catch (e) {
      return null;
    }
  }

  bool isInWatchList(Actor actor) {
    return watchListMovies.any((a) => a.id == actor.id);
  }

  void addToWatchList(Actor actor) {
    if (watchListMovies.any((a) => a.id == actor.id)) {
      watchListMovies.remove(actor);
      Get.snackbar('Success', 'Removed from watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      watchListMovies.add(actor);
      Get.snackbar('Success', 'Added to watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }
}
