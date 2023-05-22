import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Features/Post%20Requests/request_donar_provider.dart';
import 'package:flutterdemo/Features/Post%20Requests/request_ngo_provider.dart';
import 'package:provider/provider.dart';
import '../../Data/JSON/post_json.dart';
import '../../Data/JSON/user_json.dart';
import '../Track Post/track_ngo.dart';


class RequestNgo extends StatefulWidget {
  const RequestNgo({Key? key}) : super(key: key);

  @override
  State<RequestNgo> createState() => _RequestNgoState();
}

class _RequestNgoState extends State<RequestNgo> {

  final user = FirebaseAuth.instance.currentUser!;
  bool value = false;
  List<PostJson> posts = [];
  List<UserJson> users = [];

  @override
  void initState() {
    super.initState();
    context.read<PostRequestsProvider>().fetchPosts();
    posts = context.read<PostRequestsProvider>().posts;
    print('Length:');
    print(context.read<PostRequestsProvider>().posts.length);
    //loadData();
  }

  void refresh(){
    context.read<PostRequestsProvider>().fetchPosts();
    posts = context.read<PostRequestsProvider>().posts;
    print('Length:');
    print(context.read<PostRequestsProvider>().posts.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF004643),
        centerTitle: true,
        elevation: 4,
        title: Text(
          'Posts from Donor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                          title: Padding(
                            padding:EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(posts[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF004643),
                                      fontSize: 20.0,
                                    )),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(posts[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF004643),
                                      )),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(posts[index].quantity,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF004643),
                                      )),
                                ]
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(posts[index].description,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF5A7A79),
                                )),
                          ),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              ElevatedButton.icon(
                                onPressed: () async {

                                  context.read<RequestNgoProvider>().getUserDetails(user.uid);

                                  users = context.read<RequestNgoProvider>().list;

                                  String name = users[users.length-1].name;
                                  String number = users[users.length-1].number;


                                  context.read<RequestNgoProvider>().acceptPost(user.uid, posts[index].pid, name, number);
                                  refresh();
                                  setState(() {
                                  });
                                  value = await alertBox();
                                },
                                icon: Icon(Icons.add),  //icon data for elevated button
                                label: Text("Accept"), //label text
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF004803),//elevated btton background color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }),


        floatingActionButton: FloatingActionButton(
          onPressed: () {
            refresh();
            setState(() {

          });    },
          backgroundColor: Color(0xFFFF9BC60),
          child: Icon(Icons.refresh)
        ) ,
    );
  }
  Future alertBox() async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Post has been accepted!'),
          );
        });
  }
}