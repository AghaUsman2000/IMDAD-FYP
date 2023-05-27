import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Schema/post_json.dart';
import 'finished_post_details.dart';

class RiderHistory extends StatefulWidget {
  const RiderHistory({super.key});

  @override
  RiderHistoryState createState() => RiderHistoryState();
}

class RiderHistoryState extends State<RiderHistory> {
  late Future<List<PostJson>> _postsFuture;
  final riderId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchAcceptedPosts(riderId);
  }

  Future<List<PostJson>> _fetchAcceptedPosts(String? riderId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('accepted', isEqualTo: 2)
        .where('riderUid', isEqualTo: riderId)
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
        title: const Text('Rider History'),
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
                                builder: (context) => FinishedPost(
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
