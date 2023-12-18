import 'package:flutter/material.dart';
import 'package:network_applications/models/component.dart';
import 'package:provider/provider.dart';

import '../services/get_folder_contents.dart';

class MyExplorer extends StatefulWidget {
  const MyExplorer({super.key});

  @override
  State<MyExplorer> createState() => _MyExplorerState();
}

class _MyExplorerState extends State<MyExplorer> {
  int selectedItem = -1;

  Future<void> _exploreFolder() async {
    final studentController = Provider.of<GetContents>(context, listen: false);

    // Fetch the updated posts
    await studentController.folderContentsService();

    // Now that the posts are updated, trigger a rebuild of the widget
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetContents>(
        builder: (context, componentController, child) {
      return FutureBuilder<List<MyComponent>>(
          future: componentController
              .folderContentsService(), // Use the provider here
          builder: (BuildContext context,
              AsyncSnapshot<List<MyComponent>> snapshot) {
            if (snapshot.hasData) {
              List<MyComponent> components = snapshot.data!;
              return SizedBox(
                  // width: 90,
                  child: ListView.builder(
                itemCount: components.length,
                itemBuilder: (context, index) => Container(
                    color: (index == selectedItem)
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.transparent,
                    child: GestureDetector(
                      onDoubleTap: () async => setState(() {
                        _exploreFolder();
                      }),
                      onTap: () {
                        if (selectedItem == index) {
                          setState(() {
                            selectedItem = -1;
                            selectedItem = components[index].
                          });
                        } else {
                          setState(() {
                            selectedItem = index;
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
