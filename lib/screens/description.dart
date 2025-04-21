import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:panda_tv/apis/constraints.dart';
import 'package:panda_tv/screens/trailer_play_page.dart';
import 'package:panda_tv/utils/modified_text.dart';

class Description extends ConsumerStatefulWidget {
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

  final String name, descriptionText, bannerUrl, posterUrl, launchedOn;
  final int movieId;
  final double vote;
  final List genre;

  @override
  ConsumerState<Description> createState() => _DescriptionState();
}

class _DescriptionState extends ConsumerState<Description> {
  List similarMovies = [];
  bool _loadingSimilarMovies = true;
  String _trailerYouTubeId = '';
  bool isWatchList = false;

  void _loadSimilarMovies() async {
    final Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.movieId}/similar?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        similarMovies = (data['results'] as List?) ?? [];
        _loadingSimilarMovies = false;
      });
    } else {
      setState(() {
        _loadingSimilarMovies = false;
      });

      // Optionally show an error message to the user
    }
  }

  Future<void> onTapWatchTrailer(int movieId) async {
    // Implement trailer watching logic
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'] as List;
      final trailer = results.firstWhere(
        (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
        orElse: () => null,
      );
      if (trailer != null) {
        _trailerYouTubeId = trailer['key'];

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TrailerPlayerPage(youtubeVideoId: _trailerYouTubeId),
          ),
        );
      }
    } else {
      print('Failed to load videos: ${response.statusCode}');
    }
  }

  void _navigateToDescription(dynamic movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Description(
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
          genre: [], // You might need to fetch full details for genres
          movieId: movie['id'] ?? 0,
        ),
      ),
    );
  }

  void _toggleWatchList(int movieId) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadSimilarMovies();
  }

  @override
  Widget build(BuildContext context) {
    // isWatchList = ref.watch(watchlistNotifierProvider).contains(widget.movieId);
    return Scaffold(
      backgroundColor:
          Colors.black, // Set a background color for the whole screen
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            backgroundColor:
                Colors.transparent, // Make app bar background transparent
            expandedHeight: 300,
            pinned: true, // Make the app bar stick to the top on scrolling
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              title: ModifiedText(
                text: widget.name,
                size: 22, // Slightly smaller title
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.bannerUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 50, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  // Add a gradient overlay for better text readability
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag:
                            'poster-${widget.movieId}', // Unique tag for Hero animation
                        child: Material(
                          // Wrap Image.network with Material for Hero
                          color: Colors.transparent,
                          child: Container(
                            height: 180,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(widget.posterUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ModifiedText(
                              text: widget.name,
                              size: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                ModifiedText(
                                  text: widget.vote.toStringAsFixed(1),
                                  size: 16,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 8),
                                ModifiedText(
                                  text: '(${widget.launchedOn})',
                                  size: 14,
                                  color: Colors.grey[500]!,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      onTapWatchTrailer(widget.movieId),
                                  icon: const Icon(Icons.play_arrow_outlined),
                                  label: const Text('Watch Trailer'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(isWatchList
                                      ? Icons.bookmark
                                      : Icons.bookmark_border),
                                  label: Text(isWatchList
                                      ? 'Watchlisted'
                                      : 'Watchlist'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white70,
                                    side: BorderSide(color: Colors.white70),
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ModifiedText(
                    text: 'Overview',
                    size: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  ModifiedText(
                    text: widget.descriptionText,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 24),
                  ModifiedText(
                    text: 'Similar Movies',
                    size: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  _loadingSimilarMovies
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          height: 200, // Adjust height as needed
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: similarMovies.length,
                            itemBuilder: (context, index) {
                              final similarMovie = similarMovies[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () =>
                                      _navigateToDescription(similarMovie),
                                  child: SizedBox(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  similarMovie['poster_path'] !=
                                                          null
                                                      ? 'https://image.tmdb.org/t/p/w500${similarMovie['poster_path']}'
                                                      : 'https://via.placeholder.com/150/FFFFFF/000000/?Text=No+Poster',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ModifiedText(
                                          text: similarMovie['name'] ??
                                              similarMovie['original_title'] ??
                                              'No Title',
                                          size: 12,
                                          color: Colors.white70,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
