import 'dart:developer';
import 'package:http/http.dart' as http;
import '../constants/api.dart';

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
      fileName,
      bytes,
      //contentType: MediaType('application', 'x-tar'),
    ));
    print(fileName);
    print(bytes);
    final response = await request.send();
    if (response.statusCode == 201) {
      print("Uploaded!");
      var responseString = await response.stream.bytesToString();
      print('Response: $responseString');
    } else {
      print('Failed with status code ${response.statusCode}');
      print('Error: ${response.reasonPhrase}');
    }
    print("End");
    //final response = await http.Response.fromStream(a);
    //print(response.body);
    //final responseDecoded = jsonDecode(response.body);
  } catch (e) {
    log(e.toString());
  }
}