import 'package:http/http.dart' as http;
import '../constants/api.dart';
import 'package:http_parser/http_parser.dart';

Future<bool> uploadFile(
    String fileName, List<int> bytes, int projectId, int folderId) async {
  String token = await getToken();
  var url = Uri.parse("$localHostApi/files/upload");
  var request = http.MultipartRequest("POST", url);
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';

  request.fields['filename'] = fileName;
  request.fields['projectID'] = projectId.toString();
  request.fields['folderID'] = folderId.toString();

  request.files.add(http.MultipartFile.fromBytes("file", bytes,
      filename: fileName, contentType: MediaType('*', '*')));

  final response = await request.send();
  if (response.statusCode == 201) {
    var responseString = await response.stream.bytesToString();
    print('Response: $responseString');
    return true;
  } else {
    print(
        'Failed with status code ${response.statusCode} Reason: ${response.reasonPhrase}');
    return false;
  }
}
