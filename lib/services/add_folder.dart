import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";

Future<(bool, String)> addFolderService(
    String folderName, int projectId, int folderId) async {
  Map<String, dynamic> request = {
    "name": folderName,
    "projectID": projectId,
    "folderID": folderId
  };
  String jsonPayload = json.encode(request);

  final response = await http.post(Uri.parse("$localHostApi/folders/new"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
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
