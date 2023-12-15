import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:network_applications/screens/home.dart';
import '../helpers/shared_pref_helper.dart';
import 'log_in.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PrefService _prefService = PrefService();

  @override
  void initState() {
    _prefService.readCache("token").then((value) {
      print(value.toString());
      if (value != null) {
        return Timer(Duration(seconds: 3),
                () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()), // Replace 'MainScreen' with the actual name of your main screen
          );
        });
      } else {
        return Timer(Duration(seconds: 3),
                () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()), // Replace 'MainScreen' with the actual name of your main screen
              );
            }); }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
            'assets/icons/cloud-network.json'
        ),
      ),
    );
  }
}

