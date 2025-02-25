import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static const String themeKey = "isDarkMode";
  static const String authTokenKey = "authToken";

  Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDarkMode);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false;
  }
}
