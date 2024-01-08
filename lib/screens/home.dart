import 'dart:developer';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:network_applications/components/explorer.dart';
import 'package:network_applications/components/info_pop_up.dart';
import 'package:network_applications/constants/colors.dart';
import 'package:network_applications/screens/log_in.dart';
import 'package:network_applications/components/projects_bar.dart';
import 'package:network_applications/services/Users/user_report.dart';
import 'package:network_applications/services/add_folder.dart';
import 'package:network_applications/services/check_in.dart';
import 'package:network_applications/services/upload_file.dart';
import 'package:provider/provider.dart';
import '../services/Projects/get_my_projects.dart';
import '../services/auth/log_out.dart';
import '../services/get_folder_contents.dart';
import '../services/check_out.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> checkInPopUp(List<int> list) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");
    String outputDateString = outputFormat.format(pickedDate!);
    var (bool checkedIn, String message) =
        await checkInService(list, outputDateString);
    if (checkedIn) {
      infoPopUp(context, title: "Done", info: "Checked in successfully");
      selectedForCheckIn.clear();
      refreshList();
    } else {
      infoPopUp(context, title: "Error", info: message);
    }
  }

  void _showDialogCheckOut(BuildContext context, List<int> list1) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to upload a File?'),
          actions: [
            TextButton(
              onPressed: () {
                // Handle 'Yes' button tap
                checkOutFileWithFile(list1);
                Navigator.of(context).pop();
                // Add your 'Yes' button logic here
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () async {
                // Handle 'No' button tap
                checkOutNoFile(list1);
                Navigator.of(context).pop();
                // Add your 'No' button logic here
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void checkOutNoFile(List<int> list1) async {
    if (await checkOut(list1)) {
      infoPopUp(context, title: "Done", info: "Checked out successfully");
      selectedForCheckIn.clear();
      refreshList();
    } else {
      infoPopUp(context, title: "Error", info: "Something went wrong");
    }
  }

  Future<void> checkOutFileWithFile(List<int> list) async {
    late FilePickerResult result;
    try {
      result = (await FilePicker.platform.pickFiles())!;
      PlatformFile file = result.files.first;
      List<int> bytes = file.bytes!.toList();

      if (await checkOut(list, bytes, file.name)) {
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

  Future<void> checkOutFile(List<int> list) async {
    if (list.length > 1) {
      if (await checkOut(list)) {
        infoPopUp(context, title: "Done", info: "Checked out successfully");
        selectedForCheckIn.clear();
        refreshList();
      } else {
        infoPopUp(context, title: "Error", info: "Something went wrong");
      }
    } else {
      _showDialogCheckOut(context, list);
    }
  }

  void pickFile() async {
    late FilePickerResult result;
    try {
      result = (await FilePicker.platform.pickFiles())!;
      PlatformFile file = result.files.first;
      List<int> bytes = file.bytes!.toList();
      if (await uploadFile(file.name, bytes, currentFolderId)) {
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
                    } else if (selectedProject == -1) {
                      infoPopUp(context,
                          title: "Error", info: 'Please select a project');
                    } else {
                      if (await addFolderService(folderTextController.text,
                          selectedProject, currentFolderId)) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Center(
                      child: Text('Source Safe',
                          style: TextStyle(
                            fontSize: 45,
                            letterSpacing: 8,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(-5, 5),
                                color: Color.fromARGB(50, 0, 0, 0),
                              ),
                            ],
                          ))),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: logOut,
                    icon: const Icon(Icons.logout),
                  ),
                ),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: RenderErrorBox.minimumWidth,
            child: ElevatedButton(
              onPressed: addFolderPopUp,
              child: const Text('Add Folder'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: RenderErrorBox.minimumWidth,
            child: ElevatedButton(
              onPressed: () {
                if (selectedProject == -1) {
                  infoPopUp(context,
                      title: "Error", info: 'Please select a project');
                } else {
                  pickFile();
                }
              },
              child: const Text('Add File'),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: RenderErrorBox.minimumWidth,
            child: ElevatedButton(
              onPressed: () {
                if (selectedFileId == -1) {
                  infoPopUp(context,
                      title: "Error", info: "Please select a file");
                } else {
                  List<int> checkinTemp = [];
                  checkinTemp.addAll(selectedForCheckIn);
                  checkInPopUp(checkinTemp);
                }
              },
              child: const Text('Check In'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: RenderErrorBox.minimumWidth,
            child: ElevatedButton(
              onPressed: () {
                if (selectedForCheckIn.isEmpty) {
                  infoPopUp(context,
                      title: "Error", info: "Please select a file");
                } else {
                  List<int> outTemp = [];
                  outTemp.addAll(selectedForCheckIn);
                  checkOutFile(outTemp);
                }
              },
              child: const Text('Check Out'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 280,
            child: ElevatedButton(
              onPressed: () {
                downloadUserReport(currentUserID, currentUserName);
              },
              child: const Text('Download user report'),
            ),
          ),
        ),
      ],
    );
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
