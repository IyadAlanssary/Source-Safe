import 'dart:developer';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:network_applications/components/explorer.dart';
import 'package:network_applications/screens/log_in.dart';
import 'package:network_applications/services/add_folder.dart';
import 'package:network_applications/services/check_in.dart';
import 'package:network_applications/services/download_file.dart';
import 'package:network_applications/services/log_out.dart';
import 'package:network_applications/services/upload_file.dart';
import 'package:provider/provider.dart';
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
      if (!await uploadFile(file.name!, bytes, 1, currentFolderId)) {
        showErrorPopUp("Error", "Could not upload file");
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
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    if (folderTextController.text.isEmpty) {
                      showErrorPopUp(
                          'Error', 'Please enter the folder\'s name');
                    } else {
                      if (await addFolderService(
                          folderTextController.text, 1, currentFolderId)) {
                        Navigator.of(context).pop();
                      } else {
                        showErrorPopUp("Error", "Could not add folder");
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

  void checkInPopUp() {
    final fileCheckDurationController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter days to check in file'),
            content: TextFormField(
              controller: fileCheckDurationController,
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    if (fileCheckDurationController.text.isEmpty ||
                        int.tryParse(fileCheckDurationController.text) ==
                            null) {
                      showErrorPopUp("Error", "Please enter a valid number");
                    } else {
                      String message = await checkInService(
                          selectedFileId, fileCheckDurationController.text);
                      Navigator.of(context).pop();
                      showErrorPopUp("Info", message);
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

  void showErrorPopUp(String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            Row(
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
                        showErrorPopUp("Error", "Please select a File");
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
                        showErrorPopUp("Error", "Please select a file");
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
                        showErrorPopUp("Error", "Please select a file");
                      } else {
                        //TODO check out
                      }
                    },
                    child: const Text('Check Out'),
                  ),
                ),
              ],
            ),
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
                  _refreshList();
                }),
                child: MyExplorer(folderId: currentFolderId),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    final studentController = Provider.of<GetContents>(context, listen: false);

    // Fetch the updated posts
    await studentController.folderContentsService(currentFolderId);

    // Now that the posts are updated, trigger a rebuild of the widget
    setState(() {});

    // Show a snack-bar or toast to inform the user that the refresh is complete
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
