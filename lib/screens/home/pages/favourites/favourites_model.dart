import 'package:wavy_beats/utilities/helpers.dart';
import 'package:wavy_beats/utilities/prefs.dart';

final FavouriteSongsModel favouriteTracks = FavouriteSongsModel();

class FavouriteSongsModel {
  List<String> songsPath = Preferences.getFavourites();
  List get favouriteSongs => songsPath
      .map((path) => songs.firstWhere((element) => element?["path"] == path,
          orElse: () => null))
      .where((element) => element != null)
      .toList();

  void addSong(String path) {
    songsPath.add(path);
  }

  void removeSong(String path) {
    songsPath.remove(path);
  }
}
