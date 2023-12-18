import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<String> checkInService(int fileId, String duration) async {
  Map<String, dynamic> request = {"durationInDays": duration};
  String jsonPayload = json.encode(request);

  SharedPreferences pref = await SharedPreferences.getInstance();
  var cache = pref.getString("token");

  final response =
      await http.post(Uri.parse("$localHostApi/files/$fileId/checkin"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $cache'
          },
          body: jsonPayload);
  final responseDecoded = jsonDecode(response.body);
  String message = responseDecoded["message"].toString();
  return message;
}