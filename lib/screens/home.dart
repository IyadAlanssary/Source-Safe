import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:network_applications/screens/log_in.dart';
import 'package:network_applications/services/log_out.dart';
import 'package:network_applications/services/upload_file.dart';
import '../services/get_folder_contents.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedItem = -1;
  bool isLoading = true;
  late FilePickerResult result;

  @override
  void initState() {
    getFolderContents();
    super.initState();
  }

  Future<void> getFolderContents() async {
    var (bool gotem, String data) = await getFolderContentsService();
    if (gotem) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void pickFile() async {
    try {
      result = (await FilePicker.platform.pickFiles())!;
      if (result != null) {
        PlatformFile file = result.files.first;
        List<int> bytes = file.bytes!.toList();
        uploadFile(file.name!, bytes);
      }
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : Padding(
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
                            onPressed: () async {
                              if (await logOut()) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LogIn()));
                              }
                            },
                            child: const Text("Log Out")),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: RenderErrorBox.minimumWidth,
                        child: ElevatedButton(
                          onPressed: () {},
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
                          onPressed: () {},
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => Container(
                        color: (index == selectedItem)
                            ? Colors.blue.withOpacity(0.5)
                            : Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            if (selectedItem == index) {
                              setState(() {
                                selectedItem = -1;
                              });
                            } else {
                              setState(() {
                                selectedItem = index;
                              });
                            }
                          },
                          title: Text('$index'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
