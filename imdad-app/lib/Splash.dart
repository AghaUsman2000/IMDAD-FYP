import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/login_option_screen.dart';
import 'main_screen.dart';
import 'main.dart';

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({Key? key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: animation.value,
      width: animation.value,
      child: Image.asset(
        'assets/images/Final logo.png',
        scale: 0.7,
      ),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  // late Animation<double> animation;
  // late AnimationController controller;
  // late Tween<double> turnsTween;
  // late Animation<double> anim;
  // late AnimationController controller1;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(_animationController);
    // controller = AnimationController(
    //   duration: const Duration(seconds: 1),
    //   vsync: this,
    // )..repeat(reverse: true);
    // controller1 = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // )..repeat(reverse: true);
    //
    // // animation = Tween<double>(begin: 0, end: 200).animate(controller);
    // final alpha = CurvedAnimation(parent: controller, curve: Curves.linear);
    // //animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    // animation = Tween<double>(begin: 0, end: 200).animate(alpha);
    // turnsTween = Tween<double>(
    //   begin: 2,
    //   end: 0,
    // );
    // anim = Tween.animate(controller1);
    // anim.addStatusListener((status) {
    //   print(status);
    //   if (status == AnimationStatus.completed) {
    //     turnsTween = Tween<double>(
    //       begin: 0,
    //       end: 2,
    //     );
    //     controller1.reverse();
    //   }
    // });
    // animation.addStatusListener((status) {
    //   print(status);
    //   // if (status == AnimationStatus.completed) {
    //   //   controller.reverse();//add a bool variable
    //   // }
    //   if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
    _animationController.forward();
    Future.delayed(Duration(seconds: 2), _toNextScreen);
  }

  _toNextScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MainScreen(); //MapLoader(); //if the user is logged in show home page
              } else {
                return const LoginOptionScreen(); // else show login page
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: _animation.value,
              width: _animation.value,
              child: child,
            );
          },
          child: Image.asset('assets/images/Final logo.png'),
        ),
      ),
    );
  }
}
