import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_donor_one.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_donor_provider.dart';
import 'package:provider/provider.dart';
import '../../Services/auth.dart';
import '../../main_screen.dart';
import '../Login Screens/login_donor.dart';

class SignupDonar extends StatefulWidget {
  const SignupDonar({Key? key}) : super(key: key);

  @override
  State<SignupDonar> createState() => _SignupDonarState();
}

class _SignupDonarState extends State<SignupDonar> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                bottom: screenHeight * (-0.45), child: signup_container()),
            Positioned(
              bottom: screenHeight * 0.6,
              right: 45,
              child: Container(
                  child: Image.asset(
                'assets/images/Donar_signUp_gif.png',
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class signup_container extends StatefulWidget {
  const signup_container({Key? key}) : super(key: key);

  @override
  State<signup_container> createState() => _signup_containerState();
}

class _signup_containerState extends State<signup_container> {
  final AuthService _auth = AuthService();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Color(0xFF004643),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(40.0),
              bottomLeft: Radius.circular(0))),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '    Name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller:
                    Provider.of<SignupDonorProvider>(context, listen: false)
                        .name,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF001E1D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(
                    Icons.account_circle_outlined,
                    color: Color(0xFFABD1C6),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'something went wrong enter again';
                  } else {
                    return null;
                  }
                },
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '    number',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller:
                    Provider.of<SignupDonorProvider>(context, listen: false)
                        .number,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF001E1D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Enter your number',
                  prefixIcon: const Icon(
                    Icons.numbers_rounded,
                    color: Color(0xFFABD1C6),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'something went wrong enter again';
                  } else {
                    return null;
                  }
                },
              ),

              const SizedBox(
                height: 20,
              ),

              //Login button part
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return const MainScreen(); //MapLoader(); //if the user is logged in show home page
                                } else {
                                  return const SignupDonorOne(); // else show login page
                                }
                              }),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9BC60),
                      fixedSize: const Size(330, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have a donor account?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginDonor()),
                        );
                      },
                      child: const Text(
                        'Log-In',
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
