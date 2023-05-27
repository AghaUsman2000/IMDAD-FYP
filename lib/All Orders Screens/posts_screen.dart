import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/All%20Orders%20Screens/post_details_screen.dart';
import '../Schema/post_json.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  PostScreenState createState() => PostScreenState();
}

class PostScreenState extends State<PostScreen> {
  late Future<List<PostJson>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchAcceptedPosts();
  }

  Future<List<PostJson>> _fetchAcceptedPosts() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('accepted', isEqualTo: 1)
        .get();

    return querySnapshot.docs
        .map((doc) =>
            PostJson.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<PostJson>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('${post.description}\nQuantity: ${post.quantity}'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () async {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailsScreen(
                                  post: post,
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.teal),
                          ),
                          child: const Text('View Details'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
