import 'package:flutter/material.dart';
import 'screens/log_in.dart';
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
      home: LogIn(),
    );
  }
}
