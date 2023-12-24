import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";

Future<bool> addFolderService(
    String folderName, int projectId, int folderId) async {
  Map<String, dynamic> request = {
    "name": folderName,
    "projectID": projectId,
    "folderID": folderId
  };
  String token = await getToken();
  String jsonPayload = json.encode(request);

  final response = await http.post(Uri.parse("$localHostApi/folders"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: jsonPayload);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
