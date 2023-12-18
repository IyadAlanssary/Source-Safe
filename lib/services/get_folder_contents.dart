import "dart:convert";
import "package:flutter/cupertino.dart";
import "package:http/http.dart" as http;
import "package:network_applications/constants/api.dart";
import "package:network_applications/models/component.dart";
import "package:network_applications/models/file.dart";
import "package:network_applications/models/folder.dart";
import "package:shared_preferences/shared_preferences.dart";

class GetContents extends ChangeNotifier {
  List<MyComponent> _filesAndFolders = [];
//  late final List<MyComponent> _filesAndFoldersEmpty;
  /*List<MyComponent> _files = [];
  List<MyComponent> _folders = [];*/

  Future<List<MyComponent>> folderContentsService({int? index = 1}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var cache = pref.getString("token");
    final response = await http.get(
      Uri.parse("$localHostApi/folders/$index"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $cache'
      },
    );

    // if (response.statusCode == 200) {
    final responseDecoded = jsonDecode(response.body);
    print(response.statusCode);
    // print(responseDecoded);

    final List<MyFolder> loadedFolders = [];
    final List<MyComponent> loadedComponents = [];
    List<MyFile> loadedFiles = [];
    final dataFolders = responseDecoded["data"]["folders"] as List<dynamic>;
    final dataFiles = responseDecoded["data"]["files"] as List<dynamic>;

    for (int i = 0; i < dataFolders.length; i++) {
      print("objectfsdfffffffffffffffff");
      loadedFolders.add(MyFolder(
        id: dataFolders[i]["id"],
        name: dataFolders[i]["name"],
        projectId: dataFolders[i]["project_id"],
        folderId: dataFolders[i]["folder_id"],
        createdAt: dataFolders[i]["created_at"],
        updatedAt: dataFolders[i]["updated_at"],
      ));
    }
    print("obadssdaject");
    for (int j = 0; j < dataFiles.length; j++) {
      print(" Herreee  $dataFiles");
      /*print(dataFiles[j]["id"]);
      print(dataFiles[j]["name"]);
      print(dataFiles[j]["projectID"]);
      print(dataFiles[j]["folderID"]);
      print(dataFiles[j]["created_at"]);
      print(dataFiles[j]["updated_at"]);
      print(dataFiles[j]["serverPath"]);*/
      loadedFiles.add(MyFile(
        id: dataFiles[j]["id"],
        name: dataFiles[j]["name"],
        projectId: dataFiles[j]["project_id"],
        folderId: dataFiles[j]["folder_id"],
        createdAt: dataFiles[j]["created_at"],
        updatedAt: dataFiles[j]["updated_at"],
        serverPath: dataFiles[j]["serverPath"],
        //checked: dataFiles[i]["checkedInBy"]
      ));
    }
    print(loadedFiles);
    loadedComponents.addAll(loadedFolders);
    loadedComponents.addAll(loadedFiles);
    print("sadsadasdsdad $loadedComponents ");
    _filesAndFolders = loadedComponents;
    return _filesAndFolders;
    /* } else {
      return _filesAndFoldersEmpty;
    }*/
  }

  Future<List<MyComponent>> getFilesAndFolders() async {
    notifyListeners();
    return _filesAndFolders;
  }
}
