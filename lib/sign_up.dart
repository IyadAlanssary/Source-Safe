import 'package:flutter/material.dart';
import 'package:network_applications/constant/sizes.dart';

class SignUp extends StatelessWidget {
 const SignUp({super.key});
  //   final TextEditingController _email = TextEditingController();

  // final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("network application"),
      ),
      body:  Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,

        child:  Container(
          width:   (MediaQuery.of(context).size.width),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
          gapH48,
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password ',
            ),
            
            
          ),
            ],
          ),
        ),
      ),
    );
  }
}