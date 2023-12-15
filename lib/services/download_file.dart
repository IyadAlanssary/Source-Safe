import "package:network_applications/constants/api.dart";
import 'dart:html' as html;

void downloadFile(int folderId) {
  String url = "$localHostApi/files/download/$folderId";

  html.HttpRequest request = html.HttpRequest();
  request.open('GET', url);
  request.setRequestHeader('Authorization', 'Bearer $token');

  request.responseType = 'blob';
  request.onLoad.listen((event) {
    html.AnchorElement anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(request.response));
    anchorElement.download = url.split('/').last;
    anchorElement.click();
  });
  request.send();
}