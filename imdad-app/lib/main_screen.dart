import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutterdemo/Features/Profile/profile_donar.dart';
import 'package:provider/provider.dart';
import 'Data/JSON/user_json.dart';
import 'Features/History/history_screen.dart';
import 'Features/Map Screens/home_donor.dart';
import 'Features/Map Screens/home_ngo.dart';
import 'Features/Post Food/post_food.dart';
import 'Features/Post Requests/request_donar.dart';
import 'Features/Post Requests/request_ngo.dart';
import 'Features/Profile/profile_ngo.dart';
import 'Features/Track Post/track_donar.dart';
import 'Features/Track Post/track_ngo.dart';
import 'main_screen_providor.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final user = FirebaseAuth.instance.currentUser!;
  List<UserJson> users = [];

  @override
  void initState() {
    super.initState();
    context.read<MainScreenProvider>().getUserDetails(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    users = context.watch<MainScreenProvider>().list;

    final items = <Widget>[
      const ImageIcon(AssetImage('assets/images/mapicon.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/requesticon.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/trackicon.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/post.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/profileicon.png'), size: 30),
    ];

    final items1 = <Widget>[
      const ImageIcon(AssetImage('assets/images/mapicon.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/requesticon.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/trackicon.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/historyicon.png'), size: 30),
      const ImageIcon(AssetImage('assets/images/profileicon.png'), size: 30),
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF004643),
        buttonBackgroundColor: const Color(0xFFF9BC60),
        height: 50,
        animationDuration: const Duration(milliseconds: 400),
        items: users[users.length - 1].isngo == 1 ? items1 : items,
        index: _index,
        onTap: (selectedIndex) {
          setState(() {
            _index = selectedIndex;
            print(_index);
          });
        },
      ),
      body: Container(
        color: Colors.blue,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: getSelectedPage(index: _index),
      ),
    );
  }

  Widget getSelectedPage({required int index}) {
    Widget widget = const SizedBox();
    switch (index) {
      case 0:
        if (users[users.length - 1].isngo == 1) {
          widget = HomeNgo();
        } else {
          widget = HomeDonor();
        }
        break;
      case 1:
        if (users[users.length - 1].isngo == 1) {
          widget = const RequestNgo();
        } else {
          widget = const RequestDonar();
        }
        break;
      case 2:
        if (users[users.length - 1].isngo == 1) {
          widget = const TrackNgo();
        } else {
          widget = const TrackDonar();
        }
        break;
      case 3:
        if (users[users.length - 1].isngo == 1) {
          widget = const HistoryScreen();
        } else {
          widget = const PostFood();
        } //history page here widget = MapLoader();
        break;
      case 4:
        if (users[users.length - 1].isngo == 1) {
          widget = const ProfileNgo();
        } else {
          widget = const ProfileDonar();
        }
        break;
      default:
        widget = const PostFood();
    }
    return widget;
  }
}
