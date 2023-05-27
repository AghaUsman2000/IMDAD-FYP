// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                  const SizedBox(height: 250),
                  Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Type in your Email',
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
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: _emailController.text.trim());
                                  Navigator.of(context).pop();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Success"),
                                          content: const Text(
                                              "An email has been sent to your Email Address"),
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
                                } catch (e) {
                                  Navigator.of(context).pop();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Error"),
                                          content: Text("$e"),
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
                                'Confirm'.toUpperCase(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/login/',
                                  (route) => false,
                                );
                              },
                              child: const Text.rich(TextSpan(
                                  text: ("Go back to login ?"),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: " Login here!",
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
