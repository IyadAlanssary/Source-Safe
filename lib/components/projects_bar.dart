import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'explorer.dart';
import '../models/project.dart';
import '../services/get_my_projects.dart';

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
}
