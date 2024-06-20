import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    colorScheme: const ColorScheme.light(
        primary: Color(0xffab8afd),
        secondary: Color(0xffe2dafd),
        primaryContainer: Color(0xffefeafc)),
    textTheme: const TextTheme(
        titleLarge:
            TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
    brightness: Brightness.light,
    hintColor: const Color(0xff695d88),
    scaffoldBackgroundColor: const Color(0xffffffff));

ThemeData dark = ThemeData(
    colorScheme: const ColorScheme.dark(
        primary: Color(0xffab8afd),
        secondary: Color(0xff57467e),
        primaryContainer: Color(0xff302b48)),
    textTheme: const TextTheme(
        titleLarge:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    brightness: Brightness.dark,
    hintColor: const Color(0xff695d88),
    scaffoldBackgroundColor: const Color(0xff252836));

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _pref;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeProvider() {
    _darkTheme = true;
    _loadFromPrefs();
  }
  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  // _initPref() is to iniliaze  the _pref variable

  Future<void> _initPrefs() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref?.getBool(key) ?? true;
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await _initPrefs();
    _pref?.setBool(key, _darkTheme);
  }

  // _initPrefs() async {
  //   if(_pref == null)
  //     _pref  = await SharedPreferences.getInstance();
  // }
  // _loadFromPrefs() async {
  //   await _initPrefs();
  //   _darkTheme = _pref?.getBool(key) ?? true;
  //   notifyListeners();
  // }
  // _saveToPrefs() async {
  //   await _initPrefs();
  //   _pref?.setBool(key, _darkTheme);
  // }
}
