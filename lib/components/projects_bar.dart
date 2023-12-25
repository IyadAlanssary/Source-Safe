import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../services/add_project.dart';
import 'explorer.dart';
import '../models/project.dart';
import '../services/get_my_projects.dart';
import 'info_pop_up.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  int selectedProject = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<GetProjects>(
      builder: (context, componentController, child) {
        return FutureBuilder<List<Project>>(
          future: componentController.getProjectsService(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
            if (snapshot.hasData) {
              List<Project> projects = snapshot.data!;
              return Row(
                children: [
                  Drawer(
                    width: RenderErrorBox.minimumWidth,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: projects.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(projects[index].name),
                              onTap: () {
                                setState(() {
                                  selectedProject = projects[index].id!;
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(onPressed: addProjectPopUp, icon: const Icon(Icons.add))
                      ],
                    ),
                  ),
                  Expanded(
                    child: MyExplorer(folderId: 1, projectId: selectedProject),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  void addProjectPopUp() {
    final projectTextController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter Project Name'),
            content: TextFormField(
              controller: projectTextController,
              autofocus: true,
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Add'),
                  onPressed: () async {
                    if (projectTextController.text.isEmpty) {
                      infoPopUp(context, title: "Error", info: "Please Enter Project's name");
                    } else {
                      if (await addProjectService(projectTextController.text)) {
                        Navigator.of(context).pop();
                        refreshList();
                      } else {
                        infoPopUp(context, title: "Error", info: "Could not add project");
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
    // final studentController = Provider.of<GetFolderContents>(context, listen: false);
    // await studentController.folderContentsService(currentFolderId);
    // studentController.getFilesAndFolders();

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
