import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:network_applications/constants/api.dart";
import "package:network_applications/models/component.dart";
import "package:network_applications/models/file.dart";
import "package:network_applications/models/folder.dart";
import "../helpers/shared_pref_helper.dart";

class GetFolderContents extends ChangeNotifier {
  List<MyComponent> _filesAndFolders = [];

  Future<List<MyComponent>> folderContentsService(int folderId) async {
    String token = await PrefService().readToken();
    final response = await http.get(
      Uri.parse("$localHostApi/folders/$folderId"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    final responseDecoded = jsonDecode(response.body);
    print("get files: ${response.statusCode}");
    final List<MyFolder> loadedFolders = [];
    final List<MyComponent> loadedComponents = [];
    final List<MyFile> loadedFiles = [];
    final dataFolders = responseDecoded["data"]["folders"] as List<dynamic>;
    final dataFiles = responseDecoded["data"]["files"] as List<dynamic>;

    for (int i = 0; i < dataFolders.length; i++) {
      loadedFolders.add(MyFolder(
        id: dataFolders[i]["id"],
        name: dataFolders[i]["name"],
        projectId: dataFolders[i]["project_id"],
        folderId: dataFolders[i]["folder_id"],
        createdAt: dataFolders[i]["created_at"],
        updatedAt: dataFolders[i]["updated_at"],
      ));
    }
    for (int j = 0; j < dataFiles.length; j++) {
      loadedFiles.add(MyFile(
        id: dataFiles[j]["id"],
        name: dataFiles[j]["name"],
        projectId: dataFiles[j]["project_id"],
        folderId: dataFiles[j]["folder_id"],
        createdAt: dataFiles[j]["created_at"],
        updatedAt: dataFiles[j]["updated_at"],
        checkedBy: dataFiles[j]["checkedBy"],
      ));
    }
    loadedComponents.addAll(loadedFolders);
    loadedComponents.addAll(loadedFiles);
    final df = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ");
    loadedComponents.sort((a, b) {
      return df.parseUtc(b.updatedAt).compareTo(df.parseUtc(a.updatedAt));
    });
    _filesAndFolders = loadedComponents;
    return _filesAndFolders;
  }

  Future<void> getFilesAndFolders() async {
    notifyListeners();
  }
}
