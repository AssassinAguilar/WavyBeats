import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  // Initializing

  static SharedPreferences? _prefs;
  static void init() async => _prefs = await SharedPreferences.getInstance();

  // Sleep Timer

  // Hours

  static const String _sleepTimerHkey = "sleepTimerH";

  static int getSleepTimerH() => _prefs?.getInt(_sleepTimerHkey) ?? 0;
  static void setSleepTimerH(int sleepTimerH) =>
      _prefs?.setInt(_sleepTimerHkey, sleepTimerH);

  // Minutes

  static const String _sleepTimerMkey = "sleepTimerM";

  static int getSleepTimerM() => _prefs?.getInt(_sleepTimerMkey) ?? 0;
  static void setSleepTimerM(int sleepTimerM) =>
      _prefs?.setInt(_sleepTimerMkey, sleepTimerM);

  // Play Speed

  static const String _playSpeedKey = "playSpeed";

  static double getPlaySpeed() => _prefs?.getDouble(_playSpeedKey) ?? 1;
  static void setPlaySpeed(double playSpeed) =>
      _prefs?.setDouble(_playSpeedKey, playSpeed);

  // Favourites

  static const String _favouritesKey = "favourites";

  static List<String> getFavourites() =>
      _prefs?.getStringList(_favouritesKey) ?? [];
  static void setFavourites(List<String> songsID) =>
      _prefs?.setStringList(_favouritesKey, songsID);

  // Folders

  static const String _foldersKey = "folders";

  static List<String> getFolders() => _prefs?.getStringList(_foldersKey) ?? [];
  static void setFolders(List<String> folders) =>
      _prefs?.setStringList(_foldersKey, folders);

  // Skip Silence

  static const String _skipSilence = "skipSilence";

  static bool getIsSilenceSkipped() => _prefs?.getBool(_skipSilence) ?? true;
  static void setIsSilenceSkipped(bool isSilenceSkipped) =>
      _prefs?.setBool(_skipSilence, isSilenceSkipped);

  // Skip Interval

  static const String _skipInterval = "_skipInterval";

  static int getSkipInterval() => _prefs?.getInt(_skipInterval) ?? 10;
  static void setSkipInterval(int skipInterval) =>
      _prefs?.setInt(_skipInterval, skipInterval);

  // Shuffle

  static const String _shuffleKey = "shuffle";

  static bool getIsShuffling() => _prefs?.getBool(_shuffleKey) ?? false;
  static void setIsShuffling(bool isShuffling) =>
      _prefs?.setBool(_shuffleKey, isShuffling);

  // Loop Mode

  static const String _loopModeKey = "loopMode";

  static int getLoopMode() => _prefs?.getInt(_loopModeKey) ?? 0;
  static void setLoopMode(int loopMode) =>
      _prefs?.setInt(_loopModeKey, loopMode);
}
