import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";

Future<(bool, String)> checkLogIn(String username, String password) async {
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
    return (true, token);
  } else {
    return (false, "");
  }
}
