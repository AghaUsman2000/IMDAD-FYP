import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Data/JSON/post_json.dart';
import 'history_screen_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PostJson> posts = [];
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    print(user.uid.toString());
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final fetchedPosts = await context
        .read<HistoryScreenProvider>()
        .fetchPosts(user.uid.toString());
    setState(() {
      posts = fetchedPosts;
    });
    print(posts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF004643),
        centerTitle: true,
        elevation: 4,
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<HistoryScreenProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color(0xFF004643),
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10,
                        shadowColor: const Color(0xFF004643),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(posts[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF004643),
                                        fontSize: 20.0,
                                      )),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(posts[index].title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF004643),
                                      )),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(posts[index].quantity,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF004643),
                                      )),
                                ]),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(posts[index].description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF5A7A79),
                                )),
                          ),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: const <Widget>[],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {});
          },
          backgroundColor: const Color(0xFFFF9BC60),
          child: const Icon(Icons.refresh)),
    );
  }
}
