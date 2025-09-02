
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final String apiKey = 'e0e00d0a4f892f99003ce727e780a3ec';

class HomeController extends GetxController {
  var trendingMovies = [].obs;
  var topRatedTvShows = [].obs;
  var topRatedMovies = [].obs;
  var nowPlaying = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      isLoading(true);
      await Future.wait([
        _loadNowPlaying(),
        _loadTrendingMovies(),
        _loadTopRatedShows(),
        _loadTopRatedMovies(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadNowPlaying() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      nowPlaying.value = data['results'];
    } else {
      Get.snackbar('Error', 'Failed to load Now Playing movies.');
    }
  }

  Future<void> _loadTrendingMovies() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      trendingMovies.value = data['results'];
    } else {
      Get.snackbar('Error', 'Failed to load Trending movies.');
    }
  }

  Future<void> _loadTopRatedShows() async {
    Uri url =
        Uri.parse('https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      topRatedTvShows.value = data['results'];
    } else {
      Get.snackbar('Error', 'Failed to load Top Rated Shows.');
    }
  }

  Future<void> _loadTopRatedMovies() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      topRatedMovies.value = data['results'];
    } else {
      Get.snackbar('Error', 'Failed to load Top Rated Movies.');
    }
  }
}
