import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:network_applications/constants/sizes.dart';
import 'package:network_applications/models/user.dart';
import 'package:network_applications/services/Projects/get_project_users.dart';
import 'package:network_applications/constants/colors.dart';
import 'package:network_applications/services/Projects/rename_project.dart';
import 'package:provider/provider.dart';
import '../services/Projects/add_project.dart';
import '../services/Projects/delete_project.dart';
import 'explorer.dart';
import '../models/project.dart';
import '../services/Projects/get_my_projects.dart';
import 'info_pop_up.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  int selectedProject = 1;
  bool switchStateBottom = true;

  void switchProjectIdFun(int value) {
    selectedProject = value;
  }

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
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: projects.length,
                            itemBuilder: (context, index) => ExpansionTile(
                              title: Text(projects[index].name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.drive_file_rename_outline),
                                    onPressed: () {
                                      renameProjectPopUp(projects[index].id!);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      deleteProjectPopUp(projects[index].id!);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.person),
                                    onPressed: () {
                                      addUsersDialog(id: projects[index].id!);
                                    },
                                  ),
                                ],
                              ),
                              onExpansionChanged: (bool expand) {
                                setState(() {
                                  switchProjectIdFun(projects[index].id!);
                                });
                              },
                              children: [usersDialog(id: projects[index].id!)],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: addProjectPopUp,
                            icon: const Icon(Icons.add))
                      ],
                    ),
                  ),
                  Expanded(
                    child: MyExplorer(
                        folderId: currentFolderId, projectId: selectedProject),
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
                      infoPopUp(context,
                          title: "Error", info: "Please Enter Project's name");
                    } else {
                      if (await addProjectService(projectTextController.text)) {
                        Navigator.of(context).pop();
                        refreshList();
                      } else {
                        infoPopUp(context,
                            title: "Error", info: "Could not add project");
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

  Widget usersDialog({required int id}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Consumer<GetProjectUsers>(
          builder: (context, componentController, child) {
            return FutureBuilder<List<User>>(
              future: componentController.getProjectUsersService(id),
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (snapshot.hasData) {
                  List<User> users = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.person_2),
                          title: Text(users[index].username),
                          onTap: () => {},
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ),
    );
  }

  void renameProjectPopUp(int id) {
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
                  child: const Text('Rename'),
                  onPressed: () async {
                    if (projectTextController.text.isEmpty) {
                      infoPopUp(context,
                          title: "Error", info: "Please Enter Project's name");
                    } else {
                      if (await renameProjectService(
                          id, projectTextController.text)) {
                        Navigator.of(context).pop();
                        refreshList();
                      } else {
                        infoPopUp(context,
                            title: "Error", info: "Could not rename project");
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

  void deleteProjectPopUp(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure you want to delete this project?'),
            actions: <Widget>[
              TextButton(
                  child: const Text('Yes'),
                  onPressed: () async {
                    if (await deleteProjectService(id)) {
                      Navigator.of(context).pop();
                      refreshList();
                    } else {
                      infoPopUp(context,
                          title: "Error", info: "Could not delete project");
                    }
                  }),
              TextButton(
                child: const Text('No'),
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
          backgroundColor: primary,
          content: Text(
            "Updated",
            //    style: StylesManager.medium16White(),
          )),
    );
  }
  //still under construction

  void addUsersDialog({required int id}) {
    final projectUsersTextController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.sizeOf(context).width / 2,
            height: MediaQuery.sizeOf(context).height / 2,
            child: Column(
              children: [
                TextField(
                  controller: projectUsersTextController,
                  decoration: const InputDecoration(
                    hintText: "Search for an user to add ",
                  ),
                ),
                gapH12,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<GetProjectUsers>(
                    builder: (context, componentController, child) {
                      return FutureBuilder<List<User>>(
                        future: componentController.getProjectUsersService(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<User>> snapshot) {
                          if (snapshot.hasData) {
                            List<User> users = snapshot.data!;
                            return Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.person_2),
                                    title: Text(users[index].username),
                                    onTap: () => {},
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
