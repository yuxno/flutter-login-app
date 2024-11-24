import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/widget.dart';
import 'package:login/screens/home.dart';
import 'package:login/screens/signup.dart';
import 'package:login/utils/color_utils.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, // Match screen width
        height: MediaQuery.of(context).size.height, // Match screen height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("007498"),
              hexStringToColor("00bca1"),
              hexStringToColor("acfa70"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/aa.png"),
                const SizedBox(height: 30),
                reusableTextField(
                  'Enter email',
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                buttonLogin(
                  context,
                  true,
                  () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    )
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }).catchError((error) {
                      String errorMessage;

                      // Determine the error message based on the exception
                      if (error is FirebaseAuthException) {
                        switch (error.code) {
                          case "user-not-found":
                            errorMessage = "No user found for this email.";
                            break;
                          case "wrong-password":
                            errorMessage =
                                "Incorrect password. Please try again.";
                            break;
                          case "invalid-email":
                            errorMessage = "Invalid email address.";
                            break;
                          default:
                            errorMessage =
                                "An unexpected error occurred. Please try again.";
                        }
                      } else {
                        errorMessage =
                            "An error occurred. Please check your input.";
                      }

                      // Show a dialog with the error message
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Login Failed"),
                          content: Text(errorMessage),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
