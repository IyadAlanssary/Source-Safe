import "dart:convert";

import "package:http/http.dart" as http;
import "package:network_applications/components/explorer.dart";
import "package:network_applications/constants/api.dart";
import "../helpers/shared_pref_helper.dart";
import 'package:http_parser/http_parser.dart';

import "../screens/home.dart";

Future<bool> checkOut(List<int> fileIDs,
    [List<int>? bytes, String? fileName]) async {
  String token = await PrefService().readToken();
  var url = Uri.parse("$localHostApi/files/checkout");
  var response;
  if (fileIDs.length > 1) {
    var request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    for (int i = 0; i < fileIDs.length; i++) {
      request.fields['file_ids[$i]'] = fileIDs[i].toString();
    }

    /*request.files.add(http.MultipartFile.fromBytes("file", bytes!,
        filename: fileName, contentType: MediaType('*', '*')));*/
    response = await request.send();
  } else {
    if (bytes != null) {
      var request = http.MultipartRequest("POST", url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields['file_ids[0]'] = fileIDs[0].toString();
      request.files.add(http.MultipartFile.fromBytes("file", bytes,
          filename: fileName, contentType: MediaType('*', '*')));
      response = await request.send();
    } else {
      var request = http.MultipartRequest("POST", url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.fields['file_ids[0]'] = fileIDs[0].toString();
      /*request.files.add(http.MultipartFile.fromBytes("file", bytes!,
          filename: fileName, contentType: MediaType('*', '*')));*/
      response = await request.send();
    }
  }

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
