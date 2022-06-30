import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<int> readInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getInt(key) ?? 0);
  }

  Future saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<String> readString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(key) ?? '');
  }

  Future saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future deleteString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) prefs.remove(key);
  }

  Future saveStringList(String key, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, list);
  }
}
