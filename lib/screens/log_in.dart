import 'package:flutter/material.dart';
import 'package:network_applications/screens/sign_up.dart';
import '../constants/sizes.dart';

class LogIn extends StatelessWidget {
  LogIn({super.key});

  late String username;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Log in",
              style: TextStyle(fontSize: 42),
            ),
            gapH20,
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                hintText: 'Username',
              ),
              onChanged: (value) {
                username = value;
              },
            ),
            gapH16,
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                hintText: 'Password',
              ),
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                logIn();
              },
              child: const Text('Log in'),
            ),
            gapH16,
            doNotHaveAnAccountYet(context),
          ],
        ),
      ),
    );
  }

  Row doNotHaveAnAccountYet(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account yet? ',
          style: TextStyle(fontSize: 15),
        ),
        InkWell(
            child: const Text(
              'Sign Up',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            }),
      ],
    );
  }

  void logIn() {
    //TODO Request Log In
  }
}
