import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Data/firebase_org_repository.dart';
import 'package:flutterdemo/Data/firebase_user_repository.dart';
import 'package:flutterdemo/Domain/org_respository.dart';
import 'package:flutterdemo/Features/Profile/profile_provider.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_donor_provider.dart';
import 'package:flutterdemo/Features/Signup%20Screens/signup_ngo_provider.dart';
import 'package:flutterdemo/Splash.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'Data/firebase_post_repository.dart';
import 'Domain/post_repository.dart';
import 'Domain/user_repository.dart';
import 'Features/History/history_screen_provider.dart';
import 'Features/Login Screens/login_provider.dart';
import 'Features/Map Screens/home_donor_provider.dart';
import 'Features/Map Screens/home_ngo_provider.dart';
import 'Features/Post Food/post_food_provider.dart';
import 'Features/Post Requests/request_donar_provider.dart';
import 'Features/Post Requests/request_ngo_provider.dart';
import 'Features/Track Post/track_donar_provider.dart';
import 'Features/Track Post/track_ngo_provider.dart';
import 'main_screen.dart';
import 'main_screen_providor.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// Convert your data point here
  getIt.registerSingleton<UserRepository>(FirebaseUserRepository());
  getIt.registerSingleton<OrgRepository>(FirebaseOrgRepository());
  getIt.registerSingleton<PostRepository>(FirebasePostRepository());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<HomeDonorProvider>(
        create: (_) => HomeDonorProvider(
          getIt(),
        ),
      ),
      ChangeNotifierProvider<HomeNgoProvider>(
        create: (_) => HomeNgoProvider(
          getIt(),
        ),
      ),
      ChangeNotifierProvider<PostFoodProvider>(
        create: (_) => PostFoodProvider(
          getIt(),
        ),
      ),
      ChangeNotifierProvider<PostRequestsProvider>(
        create: (_) => PostRequestsProvider(),
      ),
      ChangeNotifierProvider<SignupDonorProvider>(
        create: (_) => SignupDonorProvider(),
      ),
      ChangeNotifierProvider<SignupNgoProvider>(
        create: (_) => SignupNgoProvider(),
      ),
      ChangeNotifierProvider<LoginProvidor>(
        create: (_) => LoginProvidor(),
      ),
      ChangeNotifierProvider<TrackNgoProvider>(
        create: (_) => TrackNgoProvider(),
      ),
      ChangeNotifierProvider<PostRequestsProvider>(
        create: (_) => PostRequestsProvider(),
      ),
      ChangeNotifierProvider<ProfileProvidor>(
        create: (_) => ProfileProvidor(),
      ),
      ChangeNotifierProvider<MainScreenProvider>(
        create: (_) => MainScreenProvider(),
      ),
      ChangeNotifierProvider<HistoryScreenProvider>(
        create: (_) => HistoryScreenProvider(),
      ),
      ChangeNotifierProvider<TrackDonarProvider>(
        create: (_) => TrackDonarProvider(),
      ),
      ChangeNotifierProvider<RequestNgoProvider>(
        create: (_) => RequestNgoProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      navigatorKey: navigatorKey,

      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MainScreen(); //MapLoader(); //if the user is logged in show home page
            } else {
              return const Splash(); // else show login page
            }
          }), //Splash(), // FirebaseRepository(),// MapLoader(),//
    );
  }
}
