import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";

Future<(bool, String)> getFolderContentsService() async {
  final response = await http.get(
    Uri.parse("$localHostApi/folders/1"),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    },
  );
  final responseDecoded = jsonDecode(response.body);
  if (response.statusCode == 200) {
    String data = responseDecoded["data"].toString();
    return (true, data);
  } else {
    return (false, "");
  }
}