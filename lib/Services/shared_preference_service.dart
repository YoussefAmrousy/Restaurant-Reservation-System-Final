import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  Future<void> saveStringToLocalStorage(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getStringFromLocalStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}