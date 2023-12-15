import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCacheToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
  }

  Future readCache(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var cache = preferences.getString("$token");
    return cache;
  }

  Future removeCacheToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
  }
}