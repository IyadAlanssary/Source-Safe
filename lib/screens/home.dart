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

  void pickFile() async {
    try {
      result = (await FilePicker.platform.pickFiles())!;
      if (result != null) {
        PlatformFile file = result.files.first;
        List<int> bytes = file.bytes!.toList();
        uploadFile(file.name!, bytes, 1, 1);
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
                  onPressed: () {
                    if (folderTextController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content:
                                const Text('Please enter the folder\'s name'),
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
                    } else {
                      addFolderService(folderTextController.text, 1, 1);
                      Navigator.of(context).pop();
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
            title: const Text('Enter Duration to check in file in days'),
            content: TextFormField(
              controller: fileCheckDurationController,
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    if (fileCheckDurationController.text.isEmpty ||
                        int.tryParse(fileCheckDurationController.text) ==
                            null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content:
                                const Text('Please enter the the duration'),
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
                    } else {
                      checkInService(1, fileCheckDurationController.text);
                      Navigator.of(context).pop();
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
                      //TODO select file id
                      downloadFile(1);
                    },
                    child: const Text('Download'),
                  ),
                ),
                SizedBox(
                  width: RenderErrorBox.minimumWidth,
                  child: ElevatedButton(
                    onPressed: checkInPopUp,
                    child: const Text('Check In'),
                  ),
                ),
                SizedBox(
                  width: RenderErrorBox.minimumWidth,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Check Out'),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: MyExplorer(folderId: 1),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshList() async {
    final studentController = Provider.of<GetContents>(context, listen: false);

    // Fetch the updated posts
    await studentController.folderContentsService();

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
