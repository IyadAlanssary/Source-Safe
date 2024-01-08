import "package:network_applications/constants/api.dart";
import 'dart:html' as html;
import '../../helpers/shared_pref_helper.dart';

Future<void> downloadFileReport(int fileId, String name) async {
  String url = "$localHostApi/files/$fileId/report";
  String token = await PrefService().readToken();
  html.HttpRequest request = html.HttpRequest();
  request.open('GET', url);
  request.setRequestHeader('Authorization', 'Bearer $token');
  request.responseType = 'blob';

  request.onLoad.listen((event) {
    html.AnchorElement anchorElement = html.AnchorElement(
        href: html.Url.createObjectUrlFromBlob(request.response));
    print(request.status);
    anchorElement.download = "File Report $name.txt";
    anchorElement.click();
  });
  request.send();
}
