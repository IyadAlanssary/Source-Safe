import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:network_applications/constants/sizes.dart';
import 'package:network_applications/models/user.dart';
import 'package:network_applications/services/Users/add_user.dart';
import 'package:network_applications/services/Users/delete_user.dart';
import 'package:network_applications/services/Users/get_project_users.dart';
import 'package:network_applications/constants/colors.dart';
import 'package:network_applications/services/Projects/rename_project.dart';
import 'package:network_applications/services/Users/search_for_users.dart';
import 'package:provider/provider.dart';
import '../services/Projects/add_project.dart';
import '../services/Projects/delete_project.dart';
import 'explorer.dart';
import '../models/project.dart';
import '../services/Projects/get_my_projects.dart';
import 'info_pop_up.dart';

int selectedProject = -1;

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  // int selectedExpansion = -1;

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
              // List<ExpansionTileController> controllers = List.generate(
              //   projects.length,
              //   (index) => ExpansionTileController(),
              // );
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
                                      addUsersDialog(
                                          projectId: projects[index].id!);
                                    },
                                  ),
                                ],
                              ),
                              // controller: controllers[index],
                              onExpansionChanged: (bool expand) {
                                // print("expanded no. ${controllers[index]}");
                                // print("expanded no. ${controllers[index].isExpanded}");
                                setState(() {
                                  if (expand) {
                                    // selectedExpansion = index;
                                    // for (int i = 0; i < controllers.length; i++) {
                                    //   if (i != selectedExpansion) {
                                    //     print("i $i");
                                    //     controllers[i].collapse();
                                    //   }
                                    // }
                                    selectedProject = projects[index].id!;
                                    currentFolderId =
                                        projects[index].rootFolderId!;
                                    refreshList();
                                  } else {
                                    selectedProject = -1;
                                    currentFolderId = -1;
                                  }
                                });
                              },
                              children: [
                                usersDialog(projectId: projects[index].id!)
                              ],
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
                    child: (selectedProject == -1)
                        ? const Center(child: Text("Select a project"))
                        : const MyExplorer(),
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

  Widget usersDialog({required int projectId}) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Consumer<GetProjectUsers>(
        builder: (context, componentController, child) {
          return FutureBuilder<List<User>>(
            future: componentController.getProjectUsersService(projectId),
            builder:
                (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person_2),
                      title: Text(users[index].username),
                      onTap: () => {},
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person_remove_rounded),
                            onPressed: () async {
                              await deleteUserService(
                                      projectId, users[index].id, context)
                                  ? refreshUserList(projectId)
                                  : null;
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
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

  Future<void> refreshUserList(int id) async {
    final usersController =
        Provider.of<GetProjectUsers>(context, listen: false);
    await usersController.getProjectUsersService(id);
    usersController.getProjectUsersService(id);
    setState(() {});
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: primary,
          content: Text(
            "Updated",
          )),
    );
  }

  void addUsersDialog({required int projectId}) {
    bool showList = true;
    var projectUsersTextController = TextEditingController();
    void setControllerValue(var controller) {
      projectUsersTextController = controller;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) => AlertDialog(
            alignment: Alignment(-0.5, 0.2),
            content: Container(
              width: MediaQuery.sizeOf(context).width / 4,
              height: (MediaQuery.sizeOf(context).height * 3.2) / 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width / 4,
                        child: TextField(
                          controller: projectUsersTextController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search,
                                color: primary, weight: 10.0),
                            hintText: "Search for a user to add ",
                          ),
                          onChanged: (text) {
                            setState(() {
                              setControllerValue(projectUsersTextController);
                              showList = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  gapH16,
                  showList
                      ? const Text(" Search For Users")
                      : Expanded(
                          child: Consumer<SearchForUsers>(
                            builder: (context, componentController, child) {
                              return FutureBuilder<List<User>>(
                                future: componentController
                                    .getSearchForUsersServvice(
                                        projectUsersTextController.text),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<User>> snapshot) {
                                  if (snapshot.hasData) {
                                    List<User> users = snapshot.data!;
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: users.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Icon(Icons.person_2),
                                          title: Text(users[index].username),
                                          onTap: () => {
                                            setState(
                                              () {},
                                            ),
                                          },
                                          enabled: true,
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons
                                                    .person_add_alt_rounded),
                                                onPressed: () async {
                                                  await addUserService(
                                                          projectId,
                                                          users[index].id,
                                                          context)
                                                      ? refreshUserList(
                                                          projectId)
                                                      : null;
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
          ),
        );
      },
    );
  }
}
