import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../All Orders Screens/post_details_screen.dart';
import '../Schema/rider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  late final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _vehicleNumberController;
  String? _vehicleType;
  bool isRegisterPasswordVisible1 = false;
  bool isRegisterPasswordVisible2 = false;

  @override
  void initState() {
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _vehicleNumberController = TextEditingController();
    isRegisterPasswordVisible1 = false;
    isRegisterPasswordVisible2 = false;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData(primarySwatch: Colors.teal),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: const AssetImage('assets/Group.png'),
                    height: size.height * 0.25,
                  ),
                  const SizedBox(height: 30.0),
                  Text(
                    'Get On Board',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Create your profile',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Form(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                prefixIcon: Icon(Icons.person_outline_outlined),
                                labelText: "Full name",
                                hintText: 'Enter your Full name',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _phoneNumberController,
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                prefixIcon: Icon(Icons.phone),
                                labelText: "Phone",
                                hintText: 'Enter your phone number',
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                prefixIcon: Icon(Icons.man),
                                labelText: "Age",
                                hintText: 'Enter your Age',
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              return null;
                            },
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(height: 20.0),
                          DropdownButtonFormField<String>(
                            hint: const Text('Select your Vehicle Type'),
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              prefixIcon: Icon(Icons.fire_truck),
                              labelText: "Vehicle type",
                              hintText: 'Choose your vehicle',
                              border: OutlineInputBorder(),
                            ),
                            value: _vehicleType,
                            onChanged: (String? value) {
                              setState(() {
                                _vehicleType = value;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                value: 'Bike',
                                child: Text('Bike'),
                              ),
                              DropdownMenuItem(
                                value: 'Car',
                                child: Text('Car'),
                              ),
                              DropdownMenuItem(
                                value: 'Suzuki',
                                child: Text('Suzuki'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _emailController,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              prefixIcon: Icon(Icons.email),
                              labelText: "Email",
                              hintText: 'Enter your Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !isRegisterPasswordVisible1,
                            enableSuggestions: false,
                            autocorrect: false,
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
                                  isRegisterPasswordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isRegisterPasswordVisible1 =
                                        !isRegisterPasswordVisible1;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            obscureText: !isRegisterPasswordVisible2,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              prefixIcon: const Icon(Icons.key),
                              labelText: "Confirm Password",
                              hintText: 'Re-Enter password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isRegisterPasswordVisible2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isRegisterPasswordVisible2 =
                                        !isRegisterPasswordVisible2;
                                  });
                                },
                              ),
                            ),
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _vehicleNumberController,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal),
                              ),
                              prefixIcon: Icon(Icons.email),
                              labelText: "Vehicle Number",
                              hintText: 'Enter your Vehicle Number',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your vehicle number';
                              }
                              return null;
                            },
                            cursorColor: Colors.teal,
                          ),
                          const SizedBox(height: 30),
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
                                  final userCredential = await FirebaseAuth
                                      .instance
                                      .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );

                                  GeoPoint? currentLocation =
                                      await getCurrentLocation();
                                  await addRiderToFirestore(
                                    uid: userCredential.user!.uid,
                                    email: _emailController.text,
                                    name: _nameController.text,
                                    age: int.parse(_ageController.text),
                                    isRider: true,
                                    joinDate: Timestamp.now(),
                                    location: currentLocation,
                                    phoneNumber:
                                        int.parse(_phoneNumberController.text),
                                    rating: 0.0,
                                    status: 'available',
                                    vehicleType: _vehicleType,
                                    vehicleNumber:
                                        _vehicleNumberController.text,
                                  );

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Rider Registered Successfully')),
                                  );

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login/',
                                    (route) => false,
                                  );
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
                                'Register now'.toUpperCase(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login/',
                                (route) => false,
                              );
                            },
                            child:
                                const Text('Already registered? Login here!'),
                          ),
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
