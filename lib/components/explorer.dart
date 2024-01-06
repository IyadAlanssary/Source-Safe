import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:network_applications/models/component.dart';
import 'package:provider/provider.dart';
import '../models/file.dart';
import '../models/folder.dart';
import '../services/download_file.dart';
import '../services/get_folder_contents.dart';

int selectedFileId = -1;
String selectedFileName = "";
int selectedFolderId = -1;
int currentFolderId = -1;
List<int> selectedForCheckIn = [];
Queue<int> foldersQueue = Queue<int>();
int parentFolderId = 0;

class MyExplorer extends StatefulWidget {
  const MyExplorer({super.key});

  @override
  State<MyExplorer> createState() => _MyExplorerState();
}

class _MyExplorerState extends State<MyExplorer> {
  int selectedItem = -1;

  void goBack() {
    selectedForCheckIn.clear();
    setState(() {
      parentFolderId = foldersQueue.removeLast();
      currentFolderId = parentFolderId;
    });
    print('currentFolderId = $currentFolderId');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetFolderContents>(
        builder: (context, componentController, child) {
      return FutureBuilder<List<MyComponent>>(
          future: componentController.folderContentsService(currentFolderId),
          builder: (BuildContext context,
              AsyncSnapshot<List<MyComponent>> snapshot) {
            if (snapshot.hasData) {
              List<MyComponent> components = snapshot.data!;
              return Column(
                children: [
                  GestureDetector(
                      onTap: goBack,
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.arrow_back))),
                  SizedBox(
                      height: 500,
                      child: ListView.builder(
                          itemCount: components.length,
                          itemBuilder: (context, index) {
                            String checkedBy = "";
                            bool isFile = false;
                            if (components[index] is MyFile) {
                              MyFile file = components[index] as MyFile;
                              isFile = true;
                              checkedBy = file.checkedBy ?? "";
                            }
                            return Container(
                                color: (index == selectedItem)
                                    ? Colors.blue.withOpacity(0.5)
                                    : Colors.transparent,
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    if (components[index] is MyFolder) {
                                      selectedForCheckIn.clear();
                                      setState(() {
                                        currentFolderId = components[index].id;
                                        //  parentFolderId = components[index].id;
                                        foldersQueue
                                            .add(components[index].folderId);
                                        print(parentFolderId);
                                        print(
                                            'currentFolderId = $currentFolderId');
                                      });
                                    }
                                  },
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
                                          selectedFolderId =
                                              components[index].id;
                                        } else if (components[index]
                                            is MyFile) {
                                          selectedFolderId = -1;
                                          selectedFileId = components[index].id;
                                          selectedFileName =
                                              components[index].name;
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
                                                    selectedForCheckIn.add(
                                                        components[index].id);
                                                    print(selectedForCheckIn);
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                color: (selectedForCheckIn
                                                        .contains(
                                                            components[index]
                                                                .id))
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Image.asset(components[index]
                                              .icon
                                              .toString()),
                                          const SizedBox(width: 10),
                                          Text(
                                            components[index].name,
                                          ),
                                          const Spacer(),
                                          isFile == true
                                              ? IconButton(
                                                  onPressed: () {
                                                    downloadFile(selectedFileId, selectedFileName);
                                                  },
                                                  icon: const Icon(
                                                      Icons.arrow_downward))
                                              : Container(),
                                          checkedBy != ""
                                              ? Text("Checked by: $checkedBy")
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          })),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    });
  }
}
