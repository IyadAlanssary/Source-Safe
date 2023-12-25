import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
  }

  Future readToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var cache = preferences.getString("token");
    return cache;
  }

  Future removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
  }
}