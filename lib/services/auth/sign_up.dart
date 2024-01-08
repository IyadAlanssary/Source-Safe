import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import '../../helpers/shared_pref_helper.dart';

Future<bool> signUp(String userName, String password) async {
  Map<String, dynamic> request = {"username": userName, "password": password};
  String jsonPayload = json.encode(request);
  final response = await http.post(Uri.parse("$localHostApi/register"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonPayload);
  final responseDecoded = jsonDecode(response.body);
  if (response.statusCode == 201) {
    String token = responseDecoded["data"]["token"].toString();
    PrefService().createTokenAndUserName(token, userName);
    return true;
  } else {
    return false;
  }
}
