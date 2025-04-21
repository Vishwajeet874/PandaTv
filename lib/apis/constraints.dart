final apiKey = 'e0e00d0a4f892f99003ce727e780a3ec';
final val = 'Movie';

class Constraints {
  final searchMovieApi =
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$val';
  final nowShowingApi =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey';

  final topRatedShows =
      'https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey';
  final trendingMovieApi =
      'https://api.themoviedb.org/3/trending/movie/week?api_key=$apiKey';
  final nowPlayingApi =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey';
  final topRatedMovieApi =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey';

  final upcomingMovieApi =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey';

  final movieDetailsApi =
      'https://api.themoviedb.org/3/movie/{movie_id}?api_key=$apiKey';

  final similarMoviesApi =
      'https://api.themoviedb.org/3/movie/{movie_id}/similar?api_key=$apiKey';
}
