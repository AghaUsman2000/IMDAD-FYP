import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  double rating = 0;

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

  Widget buildRating() => RatingBar.builder(
        minRating: 1,
        itemSize: 46,
        itemBuilder: (context, _) =>
            const Icon(Icons.star, color: Colors.amber),
        updateOnDrag: true,
        onRatingUpdate: (rating) => setState(() {
          this.rating = rating;
        }),
      );

  void showAlertDialog(PostJson post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate your Rider'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please leave a star rating!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              buildRating(),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final riderUid = post.riderUid;
                if (riderUid != null) {
                  final riderDoc = FirebaseFirestore.instance
                      .collection('riders')
                      .doc(riderUid);
                  final riderSnapshot = await riderDoc.get();
                  if (riderSnapshot.exists) {
                    final currentRating =
                        riderSnapshot.data()?['rating'] ?? 0.0;

                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(post.pid)
                        .update(
                      {'riderRating': rating},
                    );

                    if (currentRating != 0.0) {
                      final totalRating = currentRating + rating;

                      await riderDoc.update({
                        'rating': totalRating / 2,
                      });
                    } else {
                      await riderDoc.update({
                        'rating': rating,
                      });
                    }
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
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
                              Text(
                                posts[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004643),
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                posts[index].title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004643),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                posts[index].quantity,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF004643),
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            posts[index].description,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF5A7A79),
                            ),
                          ),
                        ),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            if (posts[index].riderRating == null)
                              ElevatedButton.icon(
                                onPressed: () {
                                  showAlertDialog(posts[index]);
                                },
                                icon: const Icon(Icons.star),
                                label: const Text('Rate Rider'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF004803),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        backgroundColor: const Color(0xFFFF9BC60),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
