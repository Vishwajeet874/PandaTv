import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:panda_tv/screens/description.dart';
import 'package:panda_tv/screens/search_screen.dart';
import 'package:panda_tv/utils/modified_text.dart';
import 'package:panda_tv/widgets/movies_list.dart';
import 'package:panda_tv/widgets/shows_list.dart';

final String apiKey = 'e0e00d0a4f892f99003ce727e780a3ec';
final String accessToken =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlMGUwMGQwYTRmODkyZjk5MDAzY2U3MjdlNzgwYTNlYyIsIm5iZiI6MTc0NDU2NDM4NS4wNTYsInN1YiI6IjY3ZmJmMGExN2MyOWFlNWJjM2Q5MGE1MCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.fyTGxnboX72zTfuUh4_kfzFsycGJiylzttqkDtNPz14';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List trendingMovies = [];
  List topRatedTvShows = [];
  List topRatedMovies = [];
  List nowPlaying = [];
  bool _isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([
      _loadNowPlaying(),
      _loadTrendingMovies(),
      _loadTopRatedShows(),
      _loadTopRatedMovies(),
    ]);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadNowPlaying() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nowPlaying = data['results'];
      });
    } else {
      _showError('Failed to load Now Playing movies.');
    }
  }

  Future<void> _loadTrendingMovies() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        trendingMovies = data['results'];
      });
    } else {
      _showError('Failed to load Trending movies.');
    }
  }

  Future<void> _loadTopRatedShows() async {
    Uri url =
        Uri.parse('https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        topRatedTvShows = data['results'];
      });
    } else {
      _showError('Failed to load Top Rated Shows.');
    }
  }

  Future<void> _loadTopRatedMovies() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        topRatedMovies = data['results'];
      });
    } else {
      _showError('Failed to load Top Rated Movies.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onTapNowPlaying(movie, BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Description(
            name: movie['name'] ?? movie['original_title'],
            descriptionText: movie['overview'],
            bannerUrl:
                'https://image.tmdb.org/t/p/w500' + movie['backdrop_path'],
            posterUrl: 'https://image.tmdb.org/t/p/w500' + movie['poster_path'],
            vote: (movie['vote_average'] as num?)?.toDouble() ?? 0.0,
            launchedOn: movie['release_date'] ?? 'Not Available',
            genre: (movie['genre_ids'] as List?)?.cast<int>() ?? [],
            movieId: movie['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.redAccent, Colors.orangeAccent],
          ).createShader(bounds),
          child: ModifiedText(text: 'Panda Tv', size: 28, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAllData,
              child: Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    _buildSectionHeader('Now Playing'),
                    SizedBox(height: 5),
                    CarouselSlider.builder(
                      itemCount: nowPlaying.length,
                      itemBuilder: (context, index, realIndex) {
                        final movie = nowPlaying[index];
                        return InkWell(
                          onTap: () {
                            _onTapNowPlaying(movie, context);
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500' +
                                            movie['poster_path'],
                                      ),
                                      opacity: 0.8,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                left: 15,
                                right: 15,
                                child: ModifiedText(
                                    text: movie['name'] ??
                                        movie['original_title'],
                                    size: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 1.2,
                        autoPlayInterval: Duration(seconds: 3),
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                      ),
                    ),
                    SizedBox(height: 20),
                    MoviesList(
                      trendingList: trendingMovies,
                      headerText: 'Trending Movies',
                    ),
                    SizedBox(height: 20),
                    ShowsList(
                      trendingList: topRatedTvShows,
                      headerText: 'Top Rated Shows',
                    ),
                    SizedBox(height: 20),
                    MoviesList(
                      trendingList: topRatedMovies,
                      headerText: 'Top Rated Movies',
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ModifiedText(
        text: title,
        size: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 2.0,
            color: Colors.black,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    );
  }
}
