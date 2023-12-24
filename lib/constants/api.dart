import "package:shared_preferences/shared_preferences.dart";

const localHostApi = "http://localhost:8000/api";

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("token").toString();
}
