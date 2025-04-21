import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panda_tv/apis/constraints.dart';
import 'package:panda_tv/screens/description.dart';
import 'package:panda_tv/utils/modified_text.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String descName = '';
  String descOveview = '';
  String descBanner = '';
  String descPoster = '';
  String descLaunched = '';

  int descMovieId = 0;
  double descVote = 0;
  List<dynamic> searchResult = [];
  final TextEditingController searchTextController = TextEditingController();
  String currentSearchText = '';
  List<dynamic> trendingMovies = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTrendingMovies();
  }

  Future<List<dynamic>> searchBar(String movieVal) async {
    setState(() {
      isSearching = true;
    });
    if (movieVal.isEmpty) {
      setState(() {
        isSearching = false;
      });
      return [];
    }
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$movieVal');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data.containsKey('results')) {
        return data['results'] as List<dynamic>;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<void> _loadTrendingMovies() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('results')) {
        setState(() {
          trendingMovies = data['results'] as List<dynamic>;
        });
      }
    } else {
      print('Failed to load trending movies');
    }
  }

  void _navigateToDescription(dynamic movie) {
    String name = movie['name'] ?? movie['original_title'] ?? 'No Title';
    String overview = movie['overview'] ?? 'No overview available.';
    String bannerUrl = movie['backdrop_path'] != null
        ? 'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}'
        : '';
    String posterUrl = movie['poster_path'] != null
        ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
        : '';
    int movieId = movie['id'] ?? 0;
    double vote = (movie['vote_average'] as num?)?.toDouble() ?? 0.0;
    String launchedOn = movie['release_date'] ?? 'N/A';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Description(
            name: name,
            descriptionText: overview,
            bannerUrl: bannerUrl,
            posterUrl: posterUrl,
            vote: vote,
            launchedOn: launchedOn,
            genre: [],
            movieId: movieId),
      ),
    );
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

  Widget _buildSearchResultList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: searchResult.take(20).length,
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

  Widget _buildTrendingMoviesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // You can adjust the number of columns
        childAspectRatio: 0.7, // Adjust as needed for card proportions
      ),
      itemCount: trendingMovies.take(20).length,
      itemBuilder: (context, index) {
        return _buildMovieGridItem(context, trendingMovies[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: (value) {
                setState(() {
                  currentSearchText = value;
                  // Consider debouncing here
                });
              },
              onSubmitted: (value) {
                setState(() {
                  currentSearchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentSearchText.isNotEmpty)
                    FutureBuilder<List<dynamic>>(
                      future: searchBar(currentSearchText),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return ModifiedText(
                              text: 'Error: ${snapshot.error}',
                              size: 20,
                              color: Colors.red);
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          searchResult = snapshot.data!.take(20).toList();
                          return _buildSearchResultList();
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ModifiedText(
                                text: 'No results found.',
                                size: 16,
                                color: Colors.grey),
                          );
                        } else if (currentSearchText.isNotEmpty &&
                            !snapshot.hasData &&
                            isSearching) {
                          return Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ModifiedText(
                                text: 'Searching...',
                                size: 16,
                                color: Colors.grey),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: ModifiedText(
                                  text: 'Trending Movies',
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              if (trendingMovies.isNotEmpty)
                                _buildTrendingMoviesGrid()
                              else
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: ModifiedText(
                                      text: 'Loading trending movies...',
                                      size: 16,
                                      color: Colors.grey),
                                ),
                            ],
                          );
                        }
                      },
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: ModifiedText(
                            text: 'Trending Movies',
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        if (trendingMovies.isNotEmpty)
                          _buildTrendingMoviesGrid()
                        else
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ModifiedText(
                                text: 'Loading trending movies...',
                                size: 16,
                                color: Colors.grey),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
