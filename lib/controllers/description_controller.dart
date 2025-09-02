import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final String apiKey = 'e0e00d0a4f892f99003ce727e780a3ec';

class DescriptionController extends GetxController {
  var similarMovies = [].obs;
  var trailerKey = ''.obs;
  var isLoading = true.obs;

  final int movieId;

  DescriptionController(this.movieId);

  @override
  void onInit() {
    super.onInit();
    loadMovieData();
  }

  Future<void> loadMovieData() async {
    try {
      isLoading(true);
      await Future.wait([
        fetchSimilarMovies(),
        fetchTrailer(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSimilarMovies() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$apiKey');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('results')) {
        similarMovies.value = data['results'] as List<dynamic>;
      }
    } else {
      Get.snackbar('Error', 'Failed to load similar movies');
    }
  }

  Future<void> fetchTrailer() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('results')) {
        final videos = data['results'] as List<dynamic>;
        final trailer = videos.firstWhere(
          (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
          orElse: () => null,
        );
        print(trailer);
        if (trailer != null) {
          trailerKey.value = trailer['key'];
        }
      }
    } else {
      Get.snackbar('Error', 'Failed to load trailer');
    }
  }
}
