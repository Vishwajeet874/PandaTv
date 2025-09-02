import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_tv/controllers/home_controller.dart';
import 'package:panda_tv/screens/description.dart';
import 'package:panda_tv/screens/search_screen.dart';
import 'package:panda_tv/utils/modified_text.dart';
import 'package:panda_tv/widgets/movies_list.dart';
import 'package:panda_tv/widgets/shows_list.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

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
              Get.to(() => SearchScreen(homeController: homeController));
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: homeController.loadAllData,
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: [
                  _buildSectionHeader('Now Playing'),
                  SizedBox(height: 5),
                  CarouselSlider.builder(
                    itemCount: homeController.nowPlaying.length,
                    itemBuilder: (context, index, realIndex) {
                      final movie = homeController.nowPlaying[index];
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
                    trendingList: homeController.trendingMovies,
                    headerText: 'Trending Movies',
                  ),
                  SizedBox(height: 20),
                  ShowsList(
                    trendingList: homeController.topRatedTvShows,
                    headerText: 'Top Rated Shows',
                  ),
                  SizedBox(height: 20),
                  MoviesList(
                    trendingList: homeController.topRatedMovies,
                    headerText: 'Top Rated Movies',
                  ),
                ],
              ),
            ),
          );
        }
      }),
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

  void _onTapNowPlaying(movie, BuildContext context) {
    Get.to(() => Description(
        name: movie['name'] ?? movie['original_title'],
        descriptionText: movie['overview'],
        bannerUrl:
            'https://image.tmdb.org/t/p/w500' + movie['backdrop_path'],
        posterUrl: 'https://image.tmdb.org/t/p/w500' + movie['poster_path'],
        vote: (movie['vote_average'] as num?)?.toDouble() ?? 0.0,
        launchedOn: movie['release_date'] ?? 'Not Available',
        genre: (movie['genre_ids'] as List?)?.cast<int>() ?? [],
        movieId: movie['id']));
  }
}
