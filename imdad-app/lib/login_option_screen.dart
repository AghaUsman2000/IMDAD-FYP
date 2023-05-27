import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Features/Login Screens/login_donor.dart';
import 'Features/Login Screens/login_ngo.dart';
import 'Features/Signup Screens/signup_donor.dart';
import 'Features/Signup Screens/signup_ngo.dart';
import 'main_screen.dart';

class LoginOptionScreen extends StatefulWidget {
  const LoginOptionScreen({Key? key}) : super(key: key);
  @override
  State<LoginOptionScreen> createState() => _LoginOptionScreenState();
}

class _LoginOptionScreenState extends State<LoginOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/Final logo.png',
                scale: 0.7,
              ),
              const SizedBox(
                height: 245,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return const MainScreen(); //MapLoader(); //if the user is logged in show home page
                            } else {
                              return const LoginNGO(); // else show login page
                            }
                          }),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004643),
                    fixedSize: const Size(300, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: const Text(
                  'Login as NGO',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don’t have an NGO account?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        //add sign up page for collector
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StreamBuilder<User?>(
                                stream:
                                    FirebaseAuth.instance.authStateChanges(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return MainScreen(); //MapLoader(); //if the user is logged in show home page
                                  } else {
                                    return SignupNgo(); // else show login page
                                  }
                                }),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFFF9BC60)),
                      ))
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return MainScreen(); //MapLoader(); //if the user is logged in show home page
                              } else {
                                return LoginDonor(); // else show login page
                              }
                            }),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004643),
                      fixedSize: const Size(300, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    'Login as Donar',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don’t have a donar account?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StreamBuilder<User?>(
                                stream:
                                    FirebaseAuth.instance.authStateChanges(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return MainScreen(); //MapLoader(); //if the user is logged in show home page
                                  } else {
                                    return SignupDonar(); // else show login page
                                  }
                                }),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFFF9BC60)),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
