import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'All Orders Screens/posts_screen.dart';
import 'Authentication/forgot_password.dart';
import 'Authentication/login_screen.dart';
import 'Authentication/register_screen.dart';
import 'Firebase/firebase_options.dart';
import 'In-Progress Screen/in_progress_screen.dart';
import 'Rider History/rider_history.dart';
import 'Rider Profile/rider_profile.dart';
import 'Schema/post_json.dart';
import 'Startup Screens/animated_splash_screen.dart';
import 'Startup Screens/dashboard.dart';
import 'Startup Screens/welcome_screen.dart';
import 'Tracking Screens/ngo_track_food.dart';
import 'Tracking Screens/track_food.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AnimatedSplashScreen(),
      routes: {
        '/home/': (context) => const Dashboard(),
        '/login/': (context) => const LoginScreen(),
        '/register/': (context) => const RegistrationScreen(),
        '/posts/': (context) => const PostScreen(),
        '/profile/': (context) => const RiderProfile(),
        '/inprogress/': (context) => const InProgress(),
        '/riderhistory/': (context) => const RiderHistory(),
        '/forgotpassword/': (context) => const ForgotPasswordScreen(),
        '/welcome/': (context) => const WelcomeScreen(),
        '/trackFood/': (context) => TrackFood(
            post: ModalRoute.of(context)!.settings.arguments as PostJson),
        '/ngotrackFood/': (context) => NgoTrackFood(
            post: ModalRoute.of(context)!.settings.arguments as PostJson),
      },
    ),
  );
}
