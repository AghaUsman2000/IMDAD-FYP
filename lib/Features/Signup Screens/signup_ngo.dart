import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_ngo.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_ngo_one.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_ngo_provider.dart';
import 'package:provider/provider.dart';

import '../../Services/auth.dart';
import '../../main_screen.dart';
import '../Login Screens/login_ngo.dart';

class SignupNgo extends StatefulWidget {
  const SignupNgo({Key? key}) : super(key: key);

  @override
  State<SignupNgo> createState() => _SignupNgoState();
}

class _SignupNgoState extends State<SignupNgo> {
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

  // final nameController = TextEditingController();
  // final numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // String? val;
  // String dropdownvalue = 'Edhi Foundation';

  // List of items in our dropdown menu
  final List<String> items = [
    'Edhi Foundation',
    'JDC',
    'Chhipa',
    'Aman Foundation',
    'Akhwat Foundation',
  ];
  String? selectedValue;
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   nameController.dispose();
  //   numberController.dispose();
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final double screenwidth = MediaQuery.of(context).size.width;
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
                controller: Provider.of<SignupNgoProvider>(context, listen: false).name,
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
                  hintText: 'Enter your Name',
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
                    '    Number',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
              TextFormField(
                controller: Provider.of<SignupNgoProvider>(context, listen: false).number,
                obscureText: false,
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
                    Icons.numbers_sharp,
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

              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    children: const [
                      Icon(
                        Icons.list,
                        size: 16,
                        color: Color(0xFFF9BC60),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9BC60),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: items
                      .map((item) =>
                      DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                      Provider.of<SignupNgoProvider>(context, listen: false).organisation = selectedValue!;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Color(0xFFF9BC60),
                  iconDisabledColor: Colors.grey,
                  buttonHeight: 50,
                  buttonWidth: screenwidth*(1),
                  buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                  buttonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Color(0xFF001E1D),
                  ),
                  buttonElevation: 2,
                  itemHeight: 40,
                  itemPadding: const EdgeInsets.only(left: 14, right: 14),
                  dropdownMaxHeight: 200,
                  dropdownWidth: 300,
                  dropdownPadding: null,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Color(0xFF001E1D),
                  ),
                  dropdownElevation: 8,
                  scrollbarRadius: const Radius.circular(40),
                  scrollbarThickness: 6,
                  scrollbarAlwaysShow: true,
                  offset: const Offset(-20, 0),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData)
                                {
                                  return MainScreen();//MapLoader(); //if the user is logged in show home page
                                } else{
                                  return SignupNgoOne(); // else show login page
                                }
                              }
                          ),
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
                      )
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}