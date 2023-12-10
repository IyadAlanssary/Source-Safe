import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";

Future<bool> logOut() async {
  final response = await http.post(Uri.parse("$localHostApi/logout"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
