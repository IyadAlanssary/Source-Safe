import 'package:flutter/material.dart';
import 'package:network_applications/screens/splash_screen.dart';
import 'constants/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Source Safe',
       theme: AppTheme.lightTheme,
       debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
