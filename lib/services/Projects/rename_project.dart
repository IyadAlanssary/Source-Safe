import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/helpers/shared_pref_helper.dart";

Future<bool> renameProjectService(int id, String projectName) async {
  Map<String, dynamic> request = {
    "name": projectName,
  };
  String token = await PrefService().readToken();
  String jsonPayload = json.encode(request);

  final response = await http.put(Uri.parse("$localHostApi/projects/$id"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: jsonPayload);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}