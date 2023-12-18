import 'package:flutter/material.dart';
import 'package:network_applications/models/component.dart';
import 'package:provider/provider.dart';

import '../models/file.dart';
import '../models/folder.dart';
import '../services/get_folder_contents.dart';

class MyExplorer extends StatefulWidget {
  final int folderId;
  const MyExplorer({super.key, required this.folderId});

  @override
  State<MyExplorer> createState() => _MyExplorerState();
}

class _MyExplorerState extends State<MyExplorer> {
  int selectedItem = -1;
  int selectedFileId = -1;
  int selectedFolderId = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<GetContents>(
        builder: (context, componentController, child) {
      return FutureBuilder<List<MyComponent>>(
          future: componentController
              .folderContentsService(widget.folderId), // Use the provider here
          builder: (BuildContext context,
              AsyncSnapshot<List<MyComponent>> snapshot) {
            if (snapshot.hasData) {
              List<MyComponent> components = snapshot.data!;

              return SizedBox(
                  child: ListView.builder(
                itemCount: components.length,
                itemBuilder: (context, index) => Container(
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
                            if(components[index] is MyFolder){
                              selectedFileId = -1;
                              selectedFolderId = components[index].id;
                            }
                            else if(components[index] is MyFile){
                              selectedFolderId = -1;
                              selectedFileId = components[index].id;
                            }
                            print("File id "+selectedFileId.toString());
                            print("Folder id "+selectedFolderId.toString());
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey.shade50,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Image.asset(components[index].icon.toString()),
                              const SizedBox(width: 10),
                              Text(
                                components[index].name,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).build(context),
              ));
            }
            return const Center(child: CircularProgressIndicator());
          });
    });
  }
}
