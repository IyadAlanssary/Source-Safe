import 'dart:async';
import 'package:flutter/material.dart';
import 'package:network_applications/constants/theme.dart';
import 'package:network_applications/screens/home.dart';
import '../helpers/shared_pref_helper.dart';
import 'log_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final PrefService _prefService = PrefService();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(
      begin: -35,
      end: 0,
    ).animate(_controller);

    _prefService.readToken().then((value) {
      print(value.toString());
      if (value != null) {
        return Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        });
      } else {
        return Timer(const Duration(seconds: 2), () {
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
      body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: child,
            );
          },
          child: const Center(
              child: Text(
            'Source Safe',
            style: TextStyle(
              fontSize: 70,
              letterSpacing: 8,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(-5, 5),
                  color: Color.fromARGB(20, 0, 0, 0),
                ),
              ],
            ),
          ))),
    );
  }
}
