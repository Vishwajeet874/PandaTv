import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_tv/screens/description.dart';
import 'package:panda_tv/utils/modified_text.dart';

class ShowsList extends StatelessWidget {
  const ShowsList(
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
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingList.length,
            itemBuilder: (context, index) {
              final show = trendingList[index];
              return InkWell(
                onTap: () {
                  Get.to(() => Description(
                        name: show['name'] ?? show['original_title'] ?? 'No Title',
                        descriptionText: show['overview'] ?? 'No overview available.',
                        bannerUrl: show['backdrop_path'] != null
                            ? 'https://image.tmdb.org/t/p/w500${show['backdrop_path']}'
                            : '',
                        posterUrl: show['poster_path'] != null
                            ? 'https://image.tmdb.org/t/p/w500${show['poster_path']}'
                            : '',
                        vote: (show['vote_average'] as num?)?.toDouble() ?? 0.0,
                        launchedOn: show['release_date'] ?? 'Not Available',
                        genre: (show['genre_ids'] as List?)?.cast<int>() ?? [],
                        movieId: show['id'] ?? 0,
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  width: 250,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              show['backdrop_path'] != null
                                  ? 'https://image.tmdb.org/t/p/w500${show['backdrop_path']}'
                                  : '',
                            ),
                            fit: BoxFit.fill,
                            opacity: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ModifiedText(
                          text: show['name'] ?? show['original_title'],
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
