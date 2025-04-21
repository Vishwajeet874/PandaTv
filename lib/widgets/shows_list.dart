import 'package:flutter/material.dart';
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
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Description(
                        name: trendingList[index]['name'] ??
                            trendingList[index]['original_title'],
                        descriptionText: trendingList[index]['overview'],
                        // ignore: prefer_interpolation_to_compose_strings
                        bannerUrl: 'https://image.tmdb.org/t/p/w500' +
                            trendingList[index]['backdrop_path'],
                        // ignore: prefer_interpolation_to_compose_strings
                        posterUrl: 'https://image.tmdb.org/t/p/w500' +
                            trendingList[index]['poster_path'],
                        vote: (trendingList[index]['vote_average']),
                        launchedOn: trendingList[index]['release_date'] ??
                            'Not Available',
                        genre: trendingList[index]['genre_ids'],
                        movieId: trendingList[index]['id'],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(right: 10, top: 10),
                  width: 250,
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              // ignore: prefer_interpolation_to_compose_strings
                              'https://image.tmdb.org/t/p/w500' +
                                  trendingList[index]['backdrop_path'],
                            ),
                            fit: BoxFit.fill,
                            opacity: 0.6,
                          ),
                        ),
                      ),
                      ModifiedText(
                          text: trendingList[index]['name'] ??
                              trendingList[index]['original_title'],
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
