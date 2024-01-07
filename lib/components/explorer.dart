import 'dart:collection';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:network_applications/models/component.dart';
import 'package:network_applications/services/rename_folder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../helpers/shared_pref_helper.dart';
import '../models/file.dart';
import '../models/folder.dart';
import '../services/Projects/get_my_projects.dart';
import '../services/check_in.dart';
import '../services/check_out.dart';
import '../services/delete_file.dart';
import '../services/delete_folder.dart';
import '../services/download_file.dart';
import '../services/get_folder_contents.dart';
import 'info_pop_up.dart';

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
  String userName = "";

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  Future<void> getUserName() async {
    userName = await PrefService().readUserName();
  }

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
                                          isFile
                                              ? IconButton(
                                                  onPressed: () {
                                                    downloadFile(
                                                        components[index].id,
                                                        components[index].name);
                                                  },
                                                  icon: const Icon(
                                                      Icons.arrow_downward))
                                              : const SizedBox(width: 25,),
                                          isFile
                                              ? IconButton(
                                                  onPressed: () async {
                                                    if (await deleteFileService(
                                                        components[index].id)) {
                                                      refreshList();
                                                    } else {
                                                      infoPopUp(context,
                                                          title: "Error",
                                                          info:
                                                              "Could not delete file");
                                                    }
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete))
                                              : Container(),
                                          !isFile
                                              ? IconButton(
                                                  onPressed: () async {
                                                    if (await deleteFolderService(
                                                        components[index].id)) {
                                                      refreshList();
                                                    } else {
                                                      infoPopUp(context,
                                                          title: "Error",
                                                          info:
                                                              "Could not delete folder");
                                                    }
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete))
                                              : Container(),
                                          !isFile
                                              ? IconButton(
                                                  icon: const Icon(Icons
                                                      .drive_file_rename_outline),
                                                  onPressed: () {
                                                    renameFolderPopUp(
                                                        components[index].id);
                                                  },
                                                )
                                              : Container(),
                                          (isFile && checkedBy == "")
                                              ? IconButton(
                                                  onPressed: () {
                                                    selectedForCheckIn.clear();
                                                    selectedForCheckIn.add(
                                                        components[index].id);
                                                    setState(() {});
                                                    checkInPopUp();
                                                  },
                                                  icon: const Icon(Icons.check))
                                              : Container(),
                                          (isFile && checkedBy == userName)
                                              ? IconButton(
                                                  onPressed: () {
                                                    selectedForCheckIn.clear();
                                                    selectedForCheckIn.add(
                                                        components[index].id);
                                                    setState(() {});
                                                    checkOutFile(
                                                        components[index].id);
                                                  },
                                                  icon: const Icon(Icons
                                                      .indeterminate_check_box))
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

  void checkOutFile(int id) async {
    late FilePickerResult result;
    try {
      result = (await FilePicker.platform.pickFiles())!;
      PlatformFile file = result.files.first;
      List<int> bytes = file.bytes!.toList();
      print("File picked");
      if (await checkOut(id, bytes, file.name)) {
        infoPopUp(context, title: "Done", info: "Checked out successfully");
        refreshList();
      } else {
        infoPopUp(context, title: "Error", info: "Could not upload file");
      }
    } on PlatformException catch (e) {
      log('Unsupported operation$e');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> checkInPopUp() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String outputDateString = outputFormat.format(pickedDate!);
    var (bool checkedIn, String message) =
        await checkInService(selectedForCheckIn, outputDateString);
    if (checkedIn) {
      refreshList();
    } else {
      infoPopUp(context, title: "Error", info: message);
    }
  }

  void renameFolderPopUp(int id) {
    final folderTextController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter Folder Name'),
            content: TextFormField(
              controller: folderTextController,
              autofocus: true,
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Rename'),
                  onPressed: () async {
                    if (folderTextController.text.isEmpty) {
                      infoPopUp(context,
                          title: "Error", info: "Please Enter Folder's name");
                    } else {
                      if (await renameFolderService(
                          id, folderTextController.text)) {
                        Navigator.of(context).pop();
                        refreshList();
                      } else {
                        infoPopUp(context,
                            title: "Error", info: "Could not rename folder");
                      }
                    }
                  }),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> refreshList() async {
    final folderCtrl = Provider.of<GetFolderContents>(context, listen: false);
    await folderCtrl.folderContentsService(currentFolderId);
    folderCtrl.getFilesAndFolders();

    final projectCtrl = Provider.of<GetProjects>(context, listen: false);
    await projectCtrl.getProjectsService();
    projectCtrl.getProjectsService();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: primary,
          content: Text(
            "Updated",
          )),
    );
  }
}
