import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_tv/controllers/description_controller.dart';
import 'package:panda_tv/screens/trailer_play_page.dart';
import 'package:panda_tv/utils/modified_text.dart';
import 'package:panda_tv/widgets/movies_list.dart';

class Description extends StatelessWidget {
  final String name, descriptionText, bannerUrl, posterUrl, launchedOn;
  final double vote;
  final List<int> genre;
  final int movieId;

  const Description({
    super.key,
    required this.name,
    required this.descriptionText,
    required this.bannerUrl,
    required this.posterUrl,
    required this.vote,
    required this.launchedOn,
    required this.genre,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    final DescriptionController descriptionController =
        Get.put(DescriptionController(movieId));

    return Scaffold(
      body: Obx(() {
        if (descriptionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                    child: SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        bannerUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: ModifiedText(
                      text: '⭐ Average rating: $vote',
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: ModifiedText(
                text: name,
                size: 24,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: ModifiedText(
                text: 'Releasing on: $launchedOn',
                size: 14,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: 200,
                  width: 100,
                  child: Image.network(posterUrl),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ModifiedText(
                      text: descriptionText,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            if (descriptionController.trailerKey.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ModifiedText(
                      text: 'Trailer',
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Get.to(() => TrailerPlayPage(
                              youtubeVideoId:
                                  descriptionController.trailerKey.value,
                            ));
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(
                            'https://img.youtube.com/vi/${descriptionController.trailerKey.value}/0.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child:
                                    Text('Could not load trailer thumbnail.'),
                              );
                            },
                          ),
                          Icon(
                            Icons.play_circle_fill,
                            color: Colors.white.withOpacity(0.8),
                            size: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            MoviesList(
              trendingList: descriptionController.similarMovies,
              headerText: 'Similar Movies',
            ),
          ],
        );
      }),
    );
  }
}
