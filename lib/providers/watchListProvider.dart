import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watchListProvider.g.dart';

@riverpod
class WatchlistNotifier extends _$WatchlistNotifier {
  @override
  Set<int> build() {
    return const {};
  }

  void addToWatchList(int id) {
    if (!state.contains(id)) {
      state = {...state, id};
    }
  }

  void removeFromWatchList(int id) {
    if (state.contains(id)) {
      state = state.where((element) => element != id).toSet();
    }
  }
}
