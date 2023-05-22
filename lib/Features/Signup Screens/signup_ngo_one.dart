import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_ngo_provider.dart';
import 'package:provider/provider.dart';
import '../../Services/auth.dart';
import '../../main_screen.dart';
import '../../main.dart';
import '../Login Screens/login_ngo.dart';

class SignupNgoOne extends StatefulWidget {
  const SignupNgoOne({super.key});

  @override
  State<SignupNgoOne> createState() => _SignupNgoOneState();
}

class _SignupNgoOneState extends State<SignupNgoOne> {
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
                    'assets/images/login-collector-page-img.png',
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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

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
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '    Email',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: emailController,
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
                  hintText: 'Enter your email',
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
                height: 40,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '    Password',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
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
                    hintText: 'Enter your Password',
                    prefixIcon: const Icon(
                      Icons.vpn_key_outlined,
                      color: Color(0xFFABD1C6),
                    ),
                    suffixIcon: const Icon(
                      Icons.remove_red_eye,
                      color: Color(0xFFABD1C6),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'something went wrong enter again';
                  } else {
                    return null;
                  }
                },
              ),

              const SizedBox(
                height: 30,
              ),

              //Login button part
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Register();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF9BC60),
                      fixedSize: const Size(330, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    'Signup',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an NGO account?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginNGO()),
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

  void Register() async {
    final db = FirebaseFirestore.instance;
    // Signup Using Email and Password
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).then((value) => {
        db.collection('users').doc(value.user?.uid).set({
          'name':Provider.of<SignupNgoProvider>(context, listen: false).name.text.trim(),
          'number':Provider.of<SignupNgoProvider>(context, listen: false).number.text.trim(),
          'organisation':Provider.of<SignupNgoProvider>(context, listen: false).organisation,
          'isngo': 1,
          'email': emailController.text.trim(),
        }),
        print('Adding User with' + Provider.of<SignupNgoProvider>(context, listen: false).organisation.trim()),
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MainScreen(); //MapLoader(); //if the user is logged in show home page
              } else {
                return MainScreen(); // else show login page
              }
            }),
      ),
    );
  }
}
