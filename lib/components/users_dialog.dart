import 'package:flutter/material.dart';
import 'package:network_applications/constants/sizes.dart';
import 'package:network_applications/models/user.dart';
import 'package:network_applications/services/Users/search_for_users.dart';
import 'package:network_applications/constants/colors.dart';
import 'package:provider/provider.dart';

class UsersDialog extends StatefulWidget {
  const UsersDialog({required this.id, super.key});

  final int id;
  @override
  State<UsersDialog> createState() => _UsersDialogState();
}

class _UsersDialogState extends State<UsersDialog> {
  bool switchStateBottom = true;
  final projectUsersTextController = TextEditingController();
  void switchStateBottomFun(bool value) {
    switchStateBottom = value;
  }

  @override
  Widget build(BuildContext context) {
    return   Container(
       width: MediaQuery.sizeOf(context).width / 4,
          height: MediaQuery.sizeOf(context).height / 4,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: primary,
          ),
      
    );
  }

  void addUsersDialog({required int id}) {
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
                Consumer<SearchForUsers>(
                  builder: (context, componentController, child) {
                    return FutureBuilder<List<User>>(
                      future: componentController!.getSearchForUsersServvice(
                          projectUsersTextController.text),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
