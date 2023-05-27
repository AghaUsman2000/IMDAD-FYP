import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Features/Post%20Requests/request_donar_provider.dart';
import 'package:provider/provider.dart';

import '../../Data/JSON/post_json.dart';

class RequestDonar extends StatefulWidget {
  const RequestDonar({Key? key}) : super(key: key);

  @override
  State<RequestDonar> createState() => _RequestDonarState();
}

class _RequestDonarState extends State<RequestDonar> {
  final user = FirebaseAuth.instance.currentUser!;

  List<PostJson> posts = [];

  @override
  void initState() {
    super.initState();
    context.read<PostRequestsProvider>().fetchPosts();
    posts = context.read<PostRequestsProvider>().posts;
    print('Length:');
    print(context.read<PostRequestsProvider>().posts.length);
  }

  void refresh() {
    context.read<PostRequestsProvider>().fetchPosts();
    posts = context.read<PostRequestsProvider>().posts;
    print('Length:');
    print(context.read<PostRequestsProvider>().posts.length);
  }

  Future<void> deletePost(int index) async {
    final postId = posts[index].pid;
    try {
      // Delete the post from Firestore using the postId
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      print('Post deleted successfully.');
    } catch (e) {
      print('Error deleting post: $e');
    }
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
          'Your Posts',
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
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () {
                              deletePost(index);
                              showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      title: Text('Post Deleted Successfully!'),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text("Cancel"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
          setState(() {});
        },
        backgroundColor: const Color(0xFFF9BC60),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
