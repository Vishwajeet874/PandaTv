import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_tv/screens/description.dart';
import 'package:panda_tv/utils/modified_text.dart';

class MoviesList extends StatelessWidget {
  const MoviesList(
      {super.key, required this.trendingList, required this.headerText});

  final List trendingList;
  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModifiedText(
          text: headerText,
          size: 24,
          color: Colors.white,
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingList.length,
            itemBuilder: (context, index) {
              final movie = trendingList[index];
              return InkWell(
                onTap: () {
                  Get.to(() => Description(
                        name: movie['name'] ?? movie['original_title'],
                        descriptionText: movie['overview'],
                        bannerUrl:
                            'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}',
                        posterUrl:
                            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        vote: (movie['vote_average'] as num?)?.toDouble() ?? 0.0,
                        launchedOn: movie['release_date'] ?? 'Not Available',
                        genre: (movie['genre_ids'] as List?)?.cast<int>() ?? [],
                        movieId: movie['id'],
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  width: 140,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ModifiedText(
                          text: movie['name'] ?? movie['original_title'],
                          size: 12,
                          color: Colors.white)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
