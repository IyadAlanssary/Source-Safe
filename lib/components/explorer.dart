import 'package:flutter/material.dart';
import 'package:network_applications/models/component.dart';
import 'package:provider/provider.dart';

import '../models/file.dart';
import '../models/folder.dart';
import '../services/get_folder_contents.dart';

int selectedFileId = -1;
int selectedFolderId = -1;
List<int> selectedForCheckIn = [];

class MyExplorer extends StatefulWidget {
  final int folderId;
  final int projectId;

  const MyExplorer(
      {super.key, required this.folderId, required this.projectId});

  @override
  State<MyExplorer> createState() => _MyExplorerState();
}

class _MyExplorerState extends State<MyExplorer> {
  int selectedItem = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<GetFolderContents>(
        builder: (context, componentController, child) {
      return FutureBuilder<List<MyComponent>>(
          future: componentController.folderContentsService(widget.folderId),
          builder: (BuildContext context,
              AsyncSnapshot<List<MyComponent>> snapshot) {
            if (snapshot.hasData) {
              List<MyComponent> components = snapshot.data!;
              return SizedBox(
                  child: ListView.builder(
                      itemCount: components.length,
                      itemBuilder: (context, index) {
                        String checkedBy = "";
                        if (components[index] is MyFile) {
                          MyFile file = components[index] as MyFile;
                          checkedBy = file.checkedBy ?? "";
                        }
                        return Container(
                            color: (index == selectedItem)
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.transparent,
                            child: GestureDetector(
                              onTap: () {
                                if (selectedItem == index) {
                                  setState(() {
                                    selectedItem = -1;
                                    selectedFileId = -1;
                                    selectedFolderId = -1;
                                  });
                                } else {
                                  setState(() {
                                    selectedItem = index;
                                    if (components[index] is MyFolder) {
                                      selectedFileId = -1;
                                      selectedFolderId = components[index].id;
                                    } else if (components[index] is MyFile) {
                                      selectedFolderId = -1;
                                      selectedFileId = components[index].id;
                                    }
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.grey.shade50,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (selectedForCheckIn.contains(
                                                components[index].id)) {
                                              setState(() {
                                                selectedForCheckIn.remove(
                                                    components[index].id);
                                                print(selectedForCheckIn);
                                              });
                                            } else {
                                              setState(() {
                                                selectedForCheckIn
                                                    .add(components[index].id);
                                                print(selectedForCheckIn);
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            color: (selectedForCheckIn.contains(
                                                    components[index].id))
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                          components[index].icon.toString()),
                                      const SizedBox(width: 10),
                                      Text(
                                        components[index].name,
                                      ),
                                      const Spacer(),
                                      checkedBy != ""
                                          ? Text("Checked by: $checkedBy")
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      }));
            }
            return const Center(child: CircularProgressIndicator());
          });
    });
  }
}
