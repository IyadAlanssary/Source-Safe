import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/helpers/shared_pref_helper.dart";
import "package:network_applications/models/project.dart";

class GetProjects extends ChangeNotifier {
  List<Project> _projects = [];

  Future<List<Project>> getProjectsService() async {
    String token = await PrefService().readToken();
    final response = await http.get(
      Uri.parse("$localHostApi/my/projects"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    final responseDecoded = jsonDecode(response.body);
    final List<Project> loadedProjects = [];
    if (response.statusCode == 200) {
      responseDecoded["data"].forEach((v) {
        loadedProjects.add(Project.fromJson(v));
      });
      _projects = loadedProjects;
      return _projects;
    } else {
      print("error in get projects");
      return [];
    }
  }
  Future<List<Project>> getProjects() async {
    notifyListeners();
    return _projects;
  }
}
