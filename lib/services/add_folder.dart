import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<(bool, String)> addFolderService(
    String folderName, int projectId, int folderId) async {
  Map<String, dynamic> request = {
    "name": folderName,
    "projectID": projectId,
    "folderID": folderId
  };
  SharedPreferences pref = await SharedPreferences.getInstance();
  var cache = pref.getString("token");
  String jsonPayload = json.encode(request);

  final response = await http.post(Uri.parse("$localHostApi/folders"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $cache'
      },
      body: jsonPayload);
  final responseDecoded = jsonDecode(response.body);
  if (response.statusCode == 201) {
    String data = responseDecoded["data"].toString();
    print(data);
    return (true, data);
  } else {
    return (false, "");
  }
}
