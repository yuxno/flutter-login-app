import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/components/widget.dart';
import 'package:login/screens/signin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text: You're logged in
              Text(
                'You\'re logged in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20), // Space between text and image

              // Image widget (replace with your desired image)
              logoWidget("assets/images/aa2.png"),
              const SizedBox(
                  height: 40), // Space between image and logout button

              // Logout button
              ElevatedButton(
                child: Text('Logout'),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print('Signed out');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignIn()));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
