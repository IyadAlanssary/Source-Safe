import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "../helpers/shared_pref_helper.dart";

Future<bool> logOutService() async {
  final PrefService prefService = PrefService();
  String token = await getToken();
  final response = await http.post(
    Uri.parse("$localHostApi/logout"),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    print(response.body);
    await prefService.removeCacheToken(token).whenComplete(() {
      print('removed token');
    });
    return true;
  } else {
    return false;
  }
}
