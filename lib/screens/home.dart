import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:network_applications/screens/log_in.dart';
import 'package:network_applications/services/log_out.dart';
import '../services/get_files.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedItem = -1;
  bool isLoading = true;

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  Future<void> getFiles() async {
    var (bool gotem, String data) = await getFilesService();
    setState(() {
      isLoading = false;
    });
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
                          onPressed: () {},
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
                  ),
                ],
              ),
            ),
    );
  }
}
