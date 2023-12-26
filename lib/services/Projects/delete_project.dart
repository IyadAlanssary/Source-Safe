import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/helpers/shared_pref_helper.dart";

Future<bool> deleteProjectService(int id) async {
  String token = await PrefService().readToken();
  final response = await http.delete(Uri.parse("$localHostApi/projects/$id"),
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