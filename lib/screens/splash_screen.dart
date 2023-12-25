import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:network_applications/screens/home.dart';
import '../helpers/shared_pref_helper.dart';
import 'log_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PrefService _prefService = PrefService();

  @override
  void initState() {
    _prefService.readToken().then((value) {
      print(value.toString());
      if (value != null) {
        return Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        });
      } else {
        return Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LogIn()),
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/icons/cloud-network.json'),
      ),
    );
  }
}
