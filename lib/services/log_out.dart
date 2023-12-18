import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../helpers/shared_pref_helper.dart";

Future<bool> logOutService() async {

  final PrefService _prefService = PrefService();
   SharedPreferences pref = await SharedPreferences.getInstance();
  var cache = pref.getString("token");
  print(cache);
  final response = await http.post(Uri.parse("$localHostApi/logout"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $cache'
      },
  );
  if (response.statusCode == 200) {
    print(response.body);
    await _prefService.removeCacheToken(token).whenComplete(() {
      print('removed');
    });
    return true;

  } else {
    return false;
  }
}