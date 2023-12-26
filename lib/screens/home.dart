import 'dart:developer';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:network_applications/components/explorer.dart';
import 'package:network_applications/components/info_pop_up.dart';
import 'package:network_applications/screens/log_in.dart';
import 'package:network_applications/components/projects_bar.dart';
import 'package:network_applications/services/add_folder.dart';
import 'package:network_applications/services/check_in.dart';
import 'package:network_applications/services/download_file.dart';
import 'package:network_applications/services/get_my_projects.dart';
import 'package:network_applications/services/log_out.dart';
import 'package:network_applications/services/upload_file.dart';
import 'package:provider/provider.dart';
import '../services/add_project.dart';
import '../services/get_folder_contents.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FilePickerResult result;
  int currentFolderId = 1;

  void pickFile() async {
    try {
      result = (await FilePicker.platform.pickFiles())!;
      PlatformFile file = result.files.first;
      List<int> bytes = file.bytes!.toList();
      if (await uploadFile(file.name, bytes, 1, currentFolderId)) {
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

  void logOut() async {
    await logOutService().whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    });
  }

  void addFolderPopUp() {
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
                  child: const Text('Add'),
                  onPressed: () async {
                    if (folderTextController.text.isEmpty) {
                      infoPopUp(context,
                          title: "Error",
                          info: 'Please enter the folder\'s name');
                    } else {
                      if (await addFolderService(
                          folderTextController.text, 1, currentFolderId)) {
                        Navigator.of(context).pop();
                        refreshList();
                      } else {
                        infoPopUp(context,
                            title: "Error", info: "Could not add folder");
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

  Future<void> checkInPopUp() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String outputDateString = outputFormat.format(pickedDate!);
    print(outputDateString);
    var (bool checkedIn, String message) = await checkInService(selectedFileId, outputDateString);
    if (checkedIn) {
      refreshList();
    } else {
      infoPopUp(context, title: "Error", info: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Source Safe', style: TextStyle(fontSize: 36)),
                const Spacer(),
                SizedBox(
                  width: RenderErrorBox.minimumWidth,
                  child: ElevatedButton(
                      onPressed: logOut, child: const Text("Log Out")),
                )
              ],
            ),
            buildButtonsRow(),
            Expanded(
                child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                physics: const BouncingScrollPhysics(),
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad
                },
              ),
              child: RefreshIndicator(
                onRefresh: () async => setState(() {
                  refreshList();
                }),
                child: const Projects(),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Row buildButtonsRow() {
    return Row(
      children: [
        SizedBox(
          width: RenderErrorBox.minimumWidth,
          child: ElevatedButton(
            onPressed: addFolderPopUp,
            child: const Text('Add Folder'),
          ),
        ),
        SizedBox(
          width: RenderErrorBox.minimumWidth,
          child: ElevatedButton(
            onPressed: pickFile,
            child: const Text('Add File'),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: RenderErrorBox.minimumWidth,
          child: ElevatedButton(
            onPressed: () {
              if (selectedFileId == -1) {
                infoPopUp(context,
                    title: "Error", info: "Please select a file");
              } else {
                downloadFile(selectedFileId);
              }
            },
            child: const Text('Download'),
          ),
        ),
        SizedBox(
          width: RenderErrorBox.minimumWidth,
          child: ElevatedButton(
            onPressed: () {
              if (selectedFileId == -1) {
                infoPopUp(context,
                    title: "Error", info: "Please select a file");
              } else {
                checkInPopUp();
              }
            },
            child: const Text('Check In'),
          ),
        ),
        SizedBox(
          width: RenderErrorBox.minimumWidth,
          child: ElevatedButton(
            onPressed: () {
              if (selectedFileId == -1) {
                infoPopUp(context,
                    title: "Error", info: "Please select a file");
              } else {
                //TODO check out
              }
            },
            child: const Text('Check Out'),
          ),
        ),
      ],
    );
  }

  Future<void> refreshList() async {
    final studentController =
        Provider.of<GetFolderContents>(context, listen: false);
    await studentController.folderContentsService(currentFolderId);
    studentController.getFilesAndFolders();

    final controller = Provider.of<GetProjects>(context, listen: false);
    await controller.getProjectsService();
    controller.getProjectsService();

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.lightGreen,
          content: Text(
            "Updated",
            //    style: StylesManager.medium16White(),
          )),
    );
  }
}
