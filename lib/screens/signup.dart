import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/widget.dart';
import 'package:login/screens/home.dart';
import 'package:login/utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? _errorMessage; // Variable to store error message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
            child: Form(
              key: _formKey, // Form validation key
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  reusableTextField(
                    'Enter username',
                    Icons.person_outline,
                    false,
                    _usernameTextController,
                  ),
                  const SizedBox(height: 20),
                  // Custom reusable text field with validation for email
                  reusableTextField(
                    'Enter email',
                    Icons.email_outlined,
                    false,
                    _emailTextController,
                  ),
                  const SizedBox(height: 20),
                  // Custom reusable text field with validation for password
                  reusableTextField(
                    'Enter password',
                    Icons.lock_outline,
                    true,
                    _passwordTextController,
                  ),
                  const SizedBox(height: 20),
                  // Display error message if there's one
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  buttonLogin(context, false, () {
                    if (_validateInputs()) {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) {
                        print('New account created');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }).onError((error, StackTrace) {
                        setState(() {
                          _errorMessage = error.toString();
                        });
                      });
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to validate email and password
  bool _validateInputs() {
    final email = _emailTextController.text;
    final password = _passwordTextController.text;

    setState(() {
      _errorMessage = null; // Reset error message
    });

    if (email.isEmpty) {
      setState(() {
        _errorMessage = "Email is required.";
      });
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email)) {
      setState(() {
        _errorMessage = "Enter a valid email.";
      });
      return false;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = "Password is required.";
      });
      return false;
    } else if (password.length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters long.";
      });
      return false;
      // } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      //   setState(() {
      //     _errorMessage = "Password must contain at least one uppercase letter.";
      //   });
      // return false;
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      setState(() {
        _errorMessage = "Password must contain at least one lowercase letter.";
      });
      return false;
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        _errorMessage = "Password must contain at least one digit.";
      });
      return false;
    }

    return true;
  }
}
