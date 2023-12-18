import "package:network_applications/constants/api.dart";
import 'dart:html' as html;

void downloadFile(int fileId) {
  String url = "$localHostApi/files/$fileId/download";

  html.HttpRequest request = html.HttpRequest();
  request.open('GET', url);
  request.setRequestHeader('Authorization', 'Bearer $token');

  // String fileName = header.split(';')[1].split('=')[1].replaceAll('"', '');

  request.responseType = 'blob';

  request.response.headers.set('Access-Control-Expose-Headers', 'Content-Disposition');
  // request.response.headers.set('Content-Disposition', 'attachment; filename="test.txt"');

  request.onLoad.listen((event) {
    html.AnchorElement anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(request.response));
    String? header = request.getResponseHeader('Content-Disposition');
    print(request.status);
    print(header);

    anchorElement.download = header;
    anchorElement.click();
  });
  request.send();
}


//
// void downloadFile2(int folderId) {
//   String url = "$localHostApi/files/download/$folderId";
//
//   http.get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'}).then((response) {
//     // Get the file name from the header
//     String header = response.headers['content-disposition']!;
//     // Extract the file name from the header
//     String fileName = header.split(';')[1].split('=')[1].replaceAll('"', '');
//     // Create a temporary file with the file name
//     List<int> bytes = response.bodyBytes;
//     // Map<String, String> options = {'type': fileName};
//     html.File tempFile = html.File(bytes, fileName);
//     // Write the file to the local file system
//     html.FileSaver saver = html.FileSaver();
//     saver.saveAs(tempFile, fileName);
//     // // Write the response body to the file
//     // tempFile.writeAsBytes(response.bodyBytes).then((file) {
//       // Open the file with the default application
//       Process.run('open', [file.path]);
//     });
//   });
// }
