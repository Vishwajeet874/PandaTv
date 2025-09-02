import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final String apiKey = 'e0e00d0a4f892f99003ce727e780a3ec';

class CustomSearchController extends GetxController {
  var searchResults = [].obs;
  var isSearching = false.obs;
  var hasSearched = false.obs;

  Future<void> search(String movieVal) async {
    try {
      isSearching(true);
      hasSearched.value = true;
      if (movieVal.isEmpty) {
        searchResults.value = [];
        return;
      }
      Uri url = Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$movieVal');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('results')) {
          searchResults.value = data['results'] as List<dynamic>;
        } else {
          searchResults.value = [];
        }
      } else {
        Get.snackbar('Error', 'Failed to load search results');
        searchResults.value = [];
      }
    } finally {
      isSearching(false);
    }
  }
}
