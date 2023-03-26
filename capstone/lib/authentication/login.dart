import 'package:capstone/authentication/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Card(
          margin:
              const EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
          elevation: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "GEEKS FOR GEEKS",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: MaterialButton(
                    color: Colors.teal[100],
                    elevation: 10,
                    onPressed: () {
                      signup(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 30.0,
                          width: 30.0,
                          // decoration: const BoxDecoration(
                          //   image: DecorationImage(
                          //       image: AssetImage(
                          //           'capstone/assets/googleimage.png'),
                          //       fit: BoxFit.cover),
                          //   shape: BoxShape.circle,
                          // ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text("Sign In with Google")
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
