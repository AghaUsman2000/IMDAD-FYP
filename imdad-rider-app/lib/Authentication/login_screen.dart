// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData(primarySwatch: Colors.teal),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: const AssetImage('assets/Donar_signUp_gif.png'),
                    height: size.height * 0.25,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'Login to your account',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Form(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                labelText: "Email",
                                hintText: 'Enter your Email',
                                border: OutlineInputBorder()),
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !isPasswordVisible,
                            maxLength: 20,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              prefixIcon: const Icon(Icons.password_outlined),
                              labelText: "Password",
                              hintText: 'Enter your password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(height: 15),
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/forgotpassword/',
                                    (route) => false,
                                  );
                                },
                                child: const Text('Forgot Password?'),
                              )),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible:
                                      false, // Prevents dismissing the dialog by tapping outside
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.teal),
                                      ),
                                    );
                                  },
                                );
                                try {
                                  CollectionReference riders = FirebaseFirestore
                                      .instance
                                      .collection('riders');
                                  UserCredential user =
                                      await _auth.signInWithEmailAndPassword(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );

                                  if (user.user != null) {
                                    DocumentSnapshot riderSnapshot =
                                        await riders.doc(user.user!.uid).get();
                                    if (riderSnapshot.exists) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        '/home/',
                                        (route) => false,
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Error"),
                                              content: const Text(
                                                  "The Rider does not exist"),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Ok"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    }
                                  }
                                } catch (e) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Error: $e"),
                                          content: const Text(
                                              "Enter your correct credentials"),
                                          actions: [
                                            TextButton(
                                              child: const Text("Ok"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50)),
                              child: Text(
                                'Login'.toUpperCase(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/register/',
                                  (route) => false,
                                );
                              },
                              child: const Text.rich(TextSpan(
                                  text: ("Don't have an account ?"),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: " Sign Up",
                                      style: TextStyle(
                                          color: Colors.teal, fontSize: 15),
                                    )
                                  ])),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
