import "dart:convert";
import "package:flutter/cupertino.dart";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/models/component.dart";
import "package:network_applications/models/file.dart";
import "package:network_applications/models/folder.dart";

class GetContents extends ChangeNotifier {
  List<MyComponent> _filesAndFolders = [];

  Future<List<MyComponent>> folderContentsService(int folderId) async {
    String token = await getToken();
    final response = await http.get(
      Uri.parse("$localHostApi/folders/$folderId"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );

    final responseDecoded = jsonDecode(response.body);
    final List<MyFolder> loadedFolders = [];
    final List<MyComponent> loadedComponents = [];
    List<MyFile> loadedFiles = [];
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
        serverPath: dataFiles[j]["serverPath"],
      ));
    }
    loadedComponents.addAll(loadedFolders);
    loadedComponents.addAll(loadedFiles);
    _filesAndFolders = loadedComponents;
    return _filesAndFolders;
  }

  Future<List<MyComponent>> getFilesAndFolders() async {
    notifyListeners();
    return _filesAndFolders;
  }
}
