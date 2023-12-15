import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants/api.dart';
import 'package:http_parser/http_parser.dart';

Future<void> uploadFile(String fileName, List<int> bytes) async {
  var url = Uri.parse("$localHostApi/files/upload");
  try {
    var request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['filename'] = fileName;
    request.fields['projectID'] = '1';
    request.fields['folderID'] = '1';

    request.files.add(http.MultipartFile.fromBytes(
      "file",
      bytes,
      filename: fileName,
      contentType: MediaType('*', '*')
    ));

    final response = await request.send();
    if (response.statusCode == 201) {
      var responseString = await response.stream.bytesToString();
      print('Response: $responseString');
    } else {
      print('Failed with status code ${response.statusCode}');
      print('Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    log(e.toString());
  }
}