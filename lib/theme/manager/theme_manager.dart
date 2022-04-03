import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wavy_beats/utilities/helpers.dart';

final ModeManager modeManager = ModeManager();
final ThemeManager themeManager = ThemeManager();

class ModeManager extends ChangeNotifier {
  final String key = "mode";
  // ignore: avoid_init_to_null
  dynamic _prefs = null;
  late String _modeName;
  late ThemeMode _mode;

  String get modeName => _modeName;
  ThemeMode get mode => _mode;

  ModeManager() {
    _modeName = modeNames[1];
    _mode = ThemeMode.values[1];
    _loadFromPrefs();
  }

  _initialPrefs() async => _prefs ??= await SharedPreferences.getInstance();

  _savePrefs(int index) async {
    await _initialPrefs();
    _prefs.setInt(key, index);
  }

  _loadFromPrefs() async {
    await _initialPrefs();
    _modeName = modeNames[_prefs.getInt(key)?.toInt() ?? 1];
    _mode = ThemeMode.values[_prefs.getInt(key)?.toInt() ?? 1];
    notifyListeners();
  }

  changeMode(int index) {
    _modeName = modeNames[index];
    _mode = ThemeMode.values[index];
    _savePrefs(index);
    notifyListeners();
  }
}

class ThemeManager extends ChangeNotifier {
  final String key = "theme";
  // ignore: avoid_init_to_null
  dynamic _prefs = null;
  late Color _primaryColor;
  late Color _primaryAccentColor;
  late String _themeName;

  Color get primaryColor => _primaryColor;
  Color get primaryAccentColor => _primaryAccentColor;
  String get themeName => _themeName;

  ThemeManager() {
    _primaryColor = themeCode[0][0];
    _primaryAccentColor = themeCode[0][1];
    _themeName = themeCode[0][2];
    _loadFromPrefs();
  }

  _initialPrefs() async => _prefs ??= await SharedPreferences.getInstance();

  _savePrefs(int index) async {
    await _initialPrefs();
    _prefs.setInt(key, index);
  }

  _loadFromPrefs() async {
    await _initialPrefs();
    _primaryColor = themeCode[_prefs.getInt(key)?.toInt() ?? 0][0];
    _primaryAccentColor = themeCode[_prefs.getInt(key)?.toInt() ?? 0][1];
    _themeName = themeCode[_prefs.getInt(key)?.toInt() ?? 0][2];
    notifyListeners();
  }

  changeTheme(int index) {
    _primaryColor = themeCode[index][0];
    _primaryAccentColor = themeCode[index][1];
    _themeName = themeCode[index][2];
    _savePrefs(index);
    notifyListeners();
  }
}
