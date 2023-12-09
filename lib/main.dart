import 'package:flutter/material.dart';
import 'package:network_applications/constant/theme.dart';
import 'package:network_applications/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Application',
       theme: AppTheme.lightTheme,
       themeMode: ThemeMode.light,
       debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}
