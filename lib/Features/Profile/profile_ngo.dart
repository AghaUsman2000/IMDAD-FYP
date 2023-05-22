import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Features/Profile/profile_provider.dart';
import 'package:flutterdemo/login_option_screen.dart';
import 'package:provider/provider.dart';

import '../../Data/JSON/user_json.dart';

class ProfileNgo extends StatefulWidget {
  const ProfileNgo({Key? key}) : super(key: key);

  @override
  State<ProfileNgo> createState() => _ProfileNgoState();
}



class _ProfileNgoState extends State<ProfileNgo> {


  final user = FirebaseAuth.instance.currentUser!;
  List<UserJson> users = [];

  @override
  void initState() {
    super.initState();

    context.read<ProfileProvidor>().getUserDetails(user.uid);
    users = context.read<ProfileProvidor>().list;

  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF004643),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60.0,
            ),

            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/Group.png'),

              radius: 80,
            ),

            const SizedBox(
              height: 5.0,
            ),
            Text(
              users[users.length-1].organisation,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFF004643)),
            ),
            const SizedBox(
              height: 1.0,
            ),

            Text(
              users[users.length-1].name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFFF9BC60)),
            ),
            const SizedBox(
              height: 1.0,
            ),

            Text(
              users[users.length-1].email,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFFF9BC60)),
            ),
            const SizedBox(
              height: 1.0,
            ),
            Text(
              users[users.length-1].number,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFFF9BC60)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Divider(
              color: Color(0xFF004643),
              height: 10,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color(0xFF004643),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                shadowColor: Color(0xFF004643),
                child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xFF004643),
                    ),
                    title: const Text("Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004643),
                        )),
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) => {
                        MaterialPageRoute(
                          builder: (context) => LoginOptionScreen(),
                        )
                      });
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}