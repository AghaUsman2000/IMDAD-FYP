import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Data/JSON/post_json.dart';

class RiderScreen extends StatelessWidget {
  final PostJson post;

  const RiderScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Information'),
        backgroundColor: const Color(0xFF004643),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('riders')
            .doc(post.riderUid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Searching for a Rider...'));
          }

          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(post.lat, post.long),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('post_location'),
                      position: LatLng(post.lat, post.long),
                      infoWindow: InfoWindow(
                          title: post.title, snippet: post.description),
                    ),
                    if (data != null && data['location'] != null)
                      Marker(
                        markerId: const MarkerId('rider_location'),
                        position: LatLng(data['location'].latitude,
                            data['location'].longitude),
                        infoWindow: InfoWindow(title: data['name']),
                      ),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  data!['name'],
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Age'),
                  subtitle: Text('Age: ${data['age'] ?? 'Not specified'}'),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Phone Number'),
                  subtitle: Text('${data['phone_number'] ?? 'Not specified'}'),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Vehicle Type'),
                  subtitle: Text('${data['vehicle_type'] ?? 'Not specified'}'),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Rider's Status"),
                  subtitle: Text(data['status']),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Rider's Rating"),
                  subtitle: Text(data['rating'].toString()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
