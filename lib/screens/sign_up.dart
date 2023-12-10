import 'package:flutter/material.dart';
import 'package:network_applications/screens/log_in.dart';
import '../constants/sizes.dart';
import '../services/sign_up.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String username;
  late String password;
  String errorMsg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign Up",
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
              onPressed: () async {
                setState(() {
                  errorMsg = "";
                });
                var (bool signedUp, String token) = await signUp(username, password);
                if(signedUp){
                  //TODO save token
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                }
                else{
                  setState(() {
                    errorMsg = "Something went wrong";
                  });
                }
              },
              child: const Text('Sign Up'),
            ),
            gapH16,
            alreadyHaveAnAccount(context),
            Text(errorMsg, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Row alreadyHaveAnAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(fontSize: 15),
        ),
        InkWell(
            child: const Text(
              'Log In',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              );
            }),
      ],
    );
  }
}
