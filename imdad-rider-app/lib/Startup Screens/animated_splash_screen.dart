import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rider_app/Startup%20Screens/welcome_screen.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  bool animate = false;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            bottom: animate ? 100 : 0,
            child: SizedBox(
              height: 700.0,
              width: 350.0,
              child: Lottie.network(
                "https://assets9.lottiefiles.com/packages/lf20_jm1zwwig.json",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => animate = true);
    await Future.delayed(const Duration(milliseconds: 5000));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()));
  }
}
