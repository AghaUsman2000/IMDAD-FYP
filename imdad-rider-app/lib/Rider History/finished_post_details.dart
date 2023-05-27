import 'package:flutter/material.dart';
import '../Schema/post_json.dart';

class FinishedPost extends StatefulWidget {
  final PostJson post;

  const FinishedPost({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  FinishedPostState createState() => FinishedPostState();
}

class FinishedPostState extends State<FinishedPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: const Text('Description of Food'),
                  subtitle: Text(widget.post.description),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Quantity'),
                  subtitle: Text(widget.post.quantity),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Name of Donor'),
                  subtitle: Text(widget.post.name),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Donor's Contact Number"),
                  subtitle: Text(widget.post.number),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Name of NGO's Representative"),
                  subtitle: Text(widget.post.nname),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("NGO Representative's Contact Number"),
                  subtitle: Text(widget.post.nnumber),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Rating Given"),
                  subtitle: Text(widget.post.riderRating.toString()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
