import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "../helpers/shared_pref_helper.dart";

Future<bool> deleteFolderService(int folderId) async {
  String token = await PrefService().readToken();
  final response = await http.delete(
    Uri.parse("$localHostApi/folders/$folderId"),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    var responseString = response.body;
    print('Response: $responseString');
    return true;
  } else {
    print(
        'Failed with status code ${response.statusCode} Reason: ${response.reasonPhrase}');
    return false;
  }
}
