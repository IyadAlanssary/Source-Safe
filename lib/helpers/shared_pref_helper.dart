import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createTokenAndUserName(String token, String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("user", userName);
  }

  Future readToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var tok = preferences.getString("token");
    return tok;
  }

  Future readUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var user = preferences.getString("user");
    return user;
  }

  Future removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
  }
}