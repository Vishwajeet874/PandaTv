import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_tv/controllers/home_controller.dart';
import 'package:panda_tv/controllers/custom_search_controller.dart';
import 'package:panda_tv/screens/description.dart';
import 'package:panda_tv/utils/modified_text.dart';

class SearchScreen extends StatelessWidget {
  final HomeController homeController;
  const SearchScreen({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final CustomSearchController searchController = Get.put(CustomSearchController());
    final TextEditingController searchTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: ModifiedText(
          text: 'Panda Tv',
          size: 26,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadiusDirectional.circular(50),
            ),
            child: TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                hintText: 'Search Movies,Series..',
                border: InputBorder.none,
                suffixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.greenAccent,
              ),
              onSubmitted: (value) {
                searchController.search(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (searchController.isSearching.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (!searchController.hasSearched.value) {
                return _buildTrendingMoviesGrid(
                    homeController.trendingMovies.toList());
              }

              if (searchController.searchResults.isEmpty) {
                return Center(
                  child: ModifiedText(
                    text: 'No results found.',
                    size: 16,
                    color: Colors.grey,
                  ),
                );
              }

              return _buildSearchResultList(
                  searchController.searchResults.toList());
            }),
          ),
        ],
      ),
    );
  }

  void _navigateToDescription(dynamic movie) {
    Get.to(() => Description(
        name: movie['name'] ?? movie['original_title'] ?? 'No Title',
        descriptionText: movie['overview'] ?? 'No overview available.',
        bannerUrl: movie['backdrop_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}'
            : '',
        posterUrl: movie['poster_path'] != null
            ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
            : '',
        vote: (movie['vote_average'] as num?)?.toDouble() ?? 0.0,
        launchedOn: movie['release_date'] ?? 'N/A',
        genre: [],
        movieId: movie['id'] ?? 0));
  }

  Widget _buildMovieGridItem(BuildContext context, dynamic movie) {
    return GestureDetector(
      onTap: () {
        _navigateToDescription(movie);
      },
      child: Card(
        color: Colors.grey[800],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: movie['poster_path'] != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported,
                            color: Colors.white);
                      },
                    )
                  : Center(
                      child: Icon(Icons.movie, size: 50, color: Colors.white),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ModifiedText(
                text: movie['name'] ?? movie['original_title'] ?? 'No Title',
                size: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultList(List<dynamic> searchResult) {
    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        final movie = searchResult[index];
        return GestureDetector(
          onTap: () {
            _navigateToDescription(movie);
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 120,
                    child: movie['poster_path'] != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image_not_supported);
                            },
                          )
                        : Icon(Icons.movie, size: 50),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ModifiedText(
                          text: movie['name'] ??
                              movie['original_title'] ??
                              'No Title',
                          size: 18,
                          color: Colors.white,
                        ),
                        if (movie['release_date'] != null)
                          ModifiedText(
                            text: 'Release: ${movie['release_date']}',
                            size: 14,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingMoviesGrid(List<dynamic> trendingMovies) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: trendingMovies.length,
      itemBuilder: (context, index) {
        return _buildMovieGridItem(context, trendingMovies[index]);
      },
    );
  }
}
