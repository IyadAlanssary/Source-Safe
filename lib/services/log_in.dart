import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/helpers/shared_pref_helper.dart";

Future<(bool, String)> checkLogIn(String username, String password) async {

  final PrefService _prefService = PrefService();

  Map<String, dynamic> request = {"username": username, "password": password};
  String jsonPayload = json.encode(request);
  final response = await http.post(Uri.parse("$localHostApi/login"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonPayload);
  final responseDecoded = jsonDecode(response.body);
  if (response.statusCode == 200) {
    String token = responseDecoded["data"]["token"].toString();
  _prefService.createCacheToken(token);
    return (true, token);
  } else {
    return (false, "");
  }
}
