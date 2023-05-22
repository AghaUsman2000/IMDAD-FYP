import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_ngo.dart';
import 'package:flutterdemo/main_screen.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'login_provider.dart';

class LoginNGO extends StatefulWidget {
  const LoginNGO({super.key});

  @override
  State<LoginNGO> createState() => _LoginNGOState();
}

class _LoginNGOState extends State<LoginNGO> {


  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: SafeArea(

        child: Stack(
          children: [
            Positioned(bottom: screenHeight*(-0.45), child: login_container_collector()),
            Positioned(bottom: screenHeight*0.55, right: 28, child: Container(child: Image.asset('assets/images/login-collector-page-img.png',scale: 1,)),),
          ],
        ),
      ),
    );
  }
}

class login_container_collector extends StatefulWidget {
  const login_container_collector({Key? key}) : super(key: key);

  @override
  State<login_container_collector> createState() => _login_container_collectorState();
}

class _login_container_collectorState extends State<login_container_collector> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isobscured = true;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height, width:MediaQuery.of(context).size.width,

      decoration: const BoxDecoration(color:  Color(0xFF004643), borderRadius: BorderRadius.only(topRight: Radius.circular(40.0), bottomRight: Radius.circular(0), topLeft: Radius.circular(40.0), bottomLeft: Radius.circular(0))),

      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Align(alignment: Alignment.topLeft, child: Text('Log-In', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white,),)
              ),
              const SizedBox(height: 40,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('    Email',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white,),),
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
                  hintStyle: const TextStyle(
                      color: Color(0xFFABD1C6)),
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.account_circle_outlined, color: Color(0xFFABD1C6),),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'something went wrong enter again';
                  }
                  else{
                    return null;
                  }
                },
              ),

              const SizedBox(height: 40,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('    Password',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),),
                ],
              ),
              TextFormField(
                obscureText: _isobscured,
                controller: passwordController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF001E1D),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),

                    ),
                    hintStyle: const TextStyle(
                        color: Color(0xFFABD1C6)),
                    hintText: 'Enter your Password',
                    prefixIcon: const Icon(Icons.vpn_key_outlined, color: Color(0xFFABD1C6),),
                    suffixIcon: IconButton(
                      icon: _isobscured? const Icon(Icons.visibility,
                        color: Color(0xFFABD1C6),): const Icon(Icons.visibility_off,
                        color: Color(0xFFABD1C6),),
                      onPressed: (){
                        setState(() {
                          _isobscured =! _isobscured;
                        });
                      },
                    )
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'something went wrong enter again';
                  }
                  else{
                    return null;
                  }
                },
              ),

              const SizedBox(height: 30,),

              //Login button part
              ElevatedButton(onPressed: (){
                if (formKey.currentState!.validate()) {
                  logIn();}
              },style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFABD1C6),fixedSize: const Size(330, 50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('Login',style: TextStyle(fontSize: 18,color: Colors.white),)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don’t have an NGO account?',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  TextButton(onPressed: (){

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SignupNgo()),
                    );


                  }, child: const Text('Sign Up',style: TextStyle(color: Color(0xFFF9BC60)),))
                ],
              ),
            ],
          ),
        ),
      ),



    );
  }
  Future logIn() async{


    context.read<LoginProvidor>().validateUser(emailController.text.trim());

    print("Length of user list:");
    print(context.read<LoginProvidor>().list.length);
    print(context.read<LoginProvidor>().list[0].organisation.toString());
    if (context.read<LoginProvidor>().list[0].organisation.toString().length > 2) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator(),));


      print("This an NGO account!");

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim()
        );
      } on FirebaseAuthException catch (error) {
        // TODO
        print(error);
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);

    }else{
      print("Error! Donor account!");
    }

  }
}