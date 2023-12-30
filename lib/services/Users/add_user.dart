import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:network_applications/components/info_pop_up.dart";
import "package:network_applications/constants/api.dart";
import "package:network_applications/helpers/shared_pref_helper.dart";

Future<bool> addUserService(
    int projectId, int userId, BuildContext context) async {
  late Map<String, dynamic> msg;
  String token = await PrefService().readToken();
  final Id = jsonEncode({
    "userID": userId,
  });
  final response = await http.post(
    Uri.parse("$localHostApi/projects/$projectId/adduser"),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer $token'
    },
    body: Id,
  );
  msg = (json.decode(response.body));

  if (response.statusCode == 200||response.statusCode == 201) {
    infoPopUp(context, title: "Success", info: " ${msg["message"]}");
    return true;
  } else {
    infoPopUp(context, title: "Error", info: "  ${msg["message"]}");
    return false;
  }
}
