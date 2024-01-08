import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/helpers/shared_pref_helper.dart";
import "package:network_applications/models/user.dart";

class SearchForUsers extends ChangeNotifier {
  List<User> _users = [];

  Future<List<User>>  getSearchForUsersServvice(String name) async {
    print(name);
    String token = await PrefService().readToken();
    final response = await http.get(
      Uri.parse("$localHostApi/users/search/$name"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    final responseDecoded = jsonDecode(response.body);
    final List<User> loadedSearchUsers = [];
    print("get Search users:${response.statusCode}");
    if (response.statusCode == 200) {
      responseDecoded["data"].forEach((v) {
        loadedSearchUsers.add(User.fromJson(v));
      });
      _users = loadedSearchUsers;
      return _users;
    } else {
      print("Error in get Search users");
      return [];
    }
  }
  Future<void> getSearchListForUsers() async {
    notifyListeners();
  }
 }
