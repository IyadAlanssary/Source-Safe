import 'package:flutter/material.dart';
import 'package:network_applications/screens/splash_screen.dart';
import 'package:network_applications/services/Projects/get_my_projects.dart';
import 'package:network_applications/services/Users/search_for_users.dart';
import 'package:network_applications/services/get_folder_contents.dart';
import 'package:network_applications/services/Users/get_project_users.dart';
import 'package:provider/provider.dart';
import 'constants/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<GetFolderContents>(
            create: (context) => GetFolderContents(),
          ),
          ChangeNotifierProvider<GetProjects>(
            create: (context) => GetProjects(),
          ),
            ChangeNotifierProvider<GetProjectUsers>(
            create: (context) => GetProjectUsers(),
          ),
              ChangeNotifierProvider<SearchForUsers>(
            create: (context) => SearchForUsers(),
          ),
        ],
        child: MaterialApp(
          title: 'Source Safe',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ));
  }
}
