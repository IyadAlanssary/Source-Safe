import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "../helpers/shared_pref_helper.dart";

Future<(bool, String)> checkInService(List<int> filesId, String date) async {
  Map<String, dynamic> request = {
    "fileIDs": filesId,
    "checkoutDate": date,
  };
  String jsonPayload = json.encode(request);
  String token = await PrefService().readToken();
  final response = await http.post(Uri.parse("$localHostApi/files/checkin"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: jsonPayload);
  final responseDecoded = jsonDecode(response.body);
  String message = responseDecoded["message"].toString();
  bool success = response.statusCode == 200;
  return (success, message);
}
