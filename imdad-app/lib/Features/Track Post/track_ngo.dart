import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/Features/Track%20Post/track_ngo_provider.dart';
import 'package:provider/provider.dart';

import '../../Data/JSON/post_json.dart';
import '../Rider Screens/donor_rider_screen.dart';

class TrackNgo extends StatefulWidget {
  const TrackNgo({Key? key}) : super(key: key);

  @override
  State<TrackNgo> createState() => _TrackNgoState();
}

class _TrackNgoState extends State<TrackNgo> {
  List<PostJson> posts = [];
  final user = FirebaseAuth.instance.currentUser!;
  bool value = false;

  @override
  void initState() {
    super.initState();
    print(user.uid.toString());
    context.read<TrackNgoProvider>().fetchPosts(user.uid.toString());
    posts = context.read<TrackNgoProvider>().posts;
    print('Length:');
    print(context.read<TrackNgoProvider>().posts.length);
    //loadData();
  }

  void refresh() {
    print(user.uid.toString());
    context.read<TrackNgoProvider>().fetchPosts(user.uid.toString());
    posts = context.read<TrackNgoProvider>().posts;
    print('Length:');
    print(context.read<TrackNgoProvider>().posts.length);
    //loadData();
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
          'Track',
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
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
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
                      trailing: FittedBox(
                        fit: BoxFit.contain,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 340,
                              width: 850,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  Clipboard.setData(
                                      ClipboardData(text: posts[index].number));
                                  value = await alertBox();
                                  // Code here
                                },
                                icon: const Icon(
                                  Icons.phone,
                                  size: 140,
                                ), //icon data for elevated button
                                label: const Text("Contact",
                                    style:
                                        TextStyle(fontSize: 170)), //label text
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  backgroundColor: const Color(
                                      0xFF004803), //elevated btton background color
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: 340,
                              width: 850,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RiderScreen(post: posts[index]),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.bike_scooter,
                                  size: 140,
                                ), //icon data for elevated button
                                label: const Text("Rider",
                                    style:
                                        TextStyle(fontSize: 170)), //label text
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: const Color(
                                      0xFF004803), //elevated btton background color
                                ),
                              ),
                            ),
                          ],
                        ),
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
          child: const Icon(Icons.refresh)),
    );
  }

  Future alertBox() async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Phone Number has been copied to clipboard!'),
          );
        });
  }
}
