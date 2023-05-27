import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  int _selectedImageIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<RequestNgoProvider>().fetchPosts();
    posts = context.read<RequestNgoProvider>().posts;
    print('Length:');
    print(context.read<RequestNgoProvider>().posts.length);
    //loadData();
  }

  void refresh() {
    context.read<RequestNgoProvider>().fetchPosts();
    posts = context.read<RequestNgoProvider>().posts;
    print('Length:');
    print(context.read<RequestNgoProvider>().posts.length);
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
                            Text(
                              posts[index].quantity,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004643),
                              ),
                            ),
                            Row(
                              children: [
                                if (posts[index].image1 != null)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedImageIndex = 0;
                                        });
                                        _showImageDialog(
                                            context, posts[index].image1!);
                                      },
                                      child: Image.network(
                                        posts[index].image1!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ),
                                if (posts[index].image2 != null)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedImageIndex = 1;
                                        });
                                        _showImageDialog(
                                            context, posts[index].image2!);
                                      },
                                      child: Image.network(
                                        posts[index].image2!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ),
                                if (posts[index].image3 != null)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedImageIndex = 2;
                                        });
                                        _showImageDialog(
                                            context, posts[index].image3!);
                                      },
                                      child: Image.network(
                                        posts[index].image3!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
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
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () async {
                              context
                                  .read<RequestNgoProvider>()
                                  .getUserDetails(user.uid);

                              users = context.read<RequestNgoProvider>().list;

                              String name = users[users.length - 1].name;
                              String number = users[users.length - 1].number;

                              context.read<RequestNgoProvider>().acceptPost(
                                  user.uid, posts[index].pid, name, number);
                              refresh();
                              setState(() {});
                              showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      title: Text('Post has been accepted!'),
                                    );
                                  });
                            },
                            icon: const Icon(
                                Icons.add), //icon data for elevated button
                            label: const Text("Accept"), //label text
                            style: ElevatedButton.styleFrom(
                              primary: const Color(
                                  0xFF004803), //elevated btton background color
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
          backgroundColor: const Color(0xFFFF9BC60),
          child: const Icon(Icons.refresh)),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
