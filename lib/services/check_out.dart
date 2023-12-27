import "dart:convert";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "../helpers/shared_pref_helper.dart";
import 'package:http_parser/http_parser.dart';

Future<bool> checkOut(int fileID, List<int> bytes, String fileName) async {
  String token = await PrefService().readToken();
  var url = Uri.parse("$localHostApi/files/$fileID/checkout");
  var request = http.MultipartRequest("POST", url);
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';
  request.fields['fileID'] = fileID.toString();
  request.files.add(http.MultipartFile.fromBytes("file", bytes,
      filename: fileName, contentType: MediaType('*', '*')));
  final response = await request.send();
  if (response.statusCode == 200) {
    var responseString = await response.stream.bytesToString();
    print('Response: $responseString');
    return true;
  } else {
    print(
        'Failed with status code ${response.statusCode} Reason: ${response.reasonPhrase}');
    return false;
  }
}
