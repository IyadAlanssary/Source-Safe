import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/helpers/shared_pref_helper.dart";
import "package:network_applications/models/user.dart";

class GetProjectUsers extends ChangeNotifier {
  List<User> _users = [];

  Future<List<User>> getProjectUsersService(int id) async {
    String token = await PrefService().readToken();
    final response = await http.get(
      Uri.parse("$localHostApi/projects/$id/users/"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    final responseDecoded = jsonDecode(response.body);
    final List<User> loadedUsers = [];
    print("get users:${response.statusCode}");
    if (response.statusCode == 200) {
      responseDecoded["data"].forEach((v) {
        loadedUsers.add(User.fromJson(v));
      });
      _users = loadedUsers;
      return _users;
    } else {
      print("Error in get users");
      return [];
    }
  }
  Future<void> getProjectUserss() async {
    notifyListeners();
  }
 }
