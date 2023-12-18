import "package:network_applications/constants/api.dart";
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> downloadFile(int fileId) async {
  String url = "$localHostApi/files/$fileId/download";
  SharedPreferences pref = await SharedPreferences.getInstance();
  var cache = pref.getString("token");

  html.HttpRequest request = html.HttpRequest();
  request.open('GET', url);
  request.setRequestHeader('Authorization', 'Bearer $cache');
  request.responseType = 'blob';

  request.onLoad.listen((event) {

    var contentDisposition = request.responseHeaders['content-disposition'];
    print('Content-Disposition: $contentDisposition');
    String? header = request.getResponseHeader('Content-Disposition');
    print('Content-Disposition: $header');

    String? fileName = header?.split(';')[1].split('=')[1].replaceAll('"', '');

    html.AnchorElement anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(request.response));
    print(request.status);

    anchorElement.download = fileName;
    anchorElement.click();
  });
  request.send();
}