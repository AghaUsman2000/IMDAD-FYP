// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Schema/post_json.dart';
import '../Startup Screens/timer.dart';

class PostDetailsScreen extends StatefulWidget {
  final PostJson post;

  const PostDetailsScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  PostDetailsScreenState createState() => PostDetailsScreenState();
}

class PostDetailsScreenState extends State<PostDetailsScreen> {
  late GoogleMapController _controller;
  late final TimerClass _timer = TimerClass();

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
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: FutureBuilder<GeoPoint?>(
                  future: getCurrentLocation(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.data == null) {
                        return const Center(
                            child: Text('Location permission denied.'));
                      } else {
                        GeoPoint currentUserLocation = snapshot.data!;
                        return SizedBox(
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  (currentUserLocation.latitude +
                                          widget.post.lat) /
                                      2,
                                  (currentUserLocation.longitude +
                                          widget.post.long) /
                                      2),
                              zoom: 13,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;
                            },
                            markers: {
                              Marker(
                                markerId: const MarkerId('post_location'),
                                position:
                                    LatLng(widget.post.lat, widget.post.long),
                                infoWindow:
                                    const InfoWindow(title: "Food's Location"),
                              ),
                              Marker(
                                markerId: const MarkerId('user_location'),
                                position: LatLng(currentUserLocation.latitude,
                                    currentUserLocation.longitude),
                                infoWindow:
                                    const InfoWindow(title: "My Location"),
                              ),
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
                width: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final riderId = FirebaseAuth.instance.currentUser?.uid;
                    final riderDoc = FirebaseFirestore.instance
                        .collection('riders')
                        .doc(riderId);
                    final riderSnapshot = await riderDoc.get();
                    String status = "";

                    if (riderSnapshot.exists) {
                      final data = riderSnapshot.data();
                      if (data != null) {
                        status = data['status'];
                      }
                    }

                    _timer.startLocationUpdates();

                    if (status == 'available' || status == 'completed') {
                      updatePostStatus(
                        riderUid: riderId,
                        postId: widget.post.pid,
                        postStatus: 3,
                      );

                      updateRiderStatus(
                        riderUid: riderId,
                        status: 'accepted',
                      );

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/trackFood/',
                        (route) => false,
                        arguments: widget.post,
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Can'r Accept Order"),
                              content: const Text(
                                  "You have an order in progress already"),
                              actions: [
                                TextButton(
                                  child: const Text("Ok"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Accept and Pick Food'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<GeoPoint?> getCurrentLocation() async {
  PermissionStatus status = await Permission.location.request();

  if (status.isGranted) {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return GeoPoint(position.latitude, position.longitude);
  } else {
    return null;
  }
}

Future<void> updateLocation() async {
  final user = FirebaseAuth.instance.currentUser;

  // Get current location
  final currentPosition = await getCurrentLocation();

  // Update user's location in Firestore
  await FirebaseFirestore.instance.collection('riders').doc(user!.uid).update({
    'location': GeoPoint(
        currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0),
  });
}

Future<void> updatePostStatus({
  required String? riderUid,
  required String postId,
  required int postStatus,
}) async {
  await FirebaseFirestore.instance.collection('posts').doc(postId).update({
    'accepted': postStatus,
    'riderUid': riderUid,
  });
}

Future<void> updateRiderStatus(
    {required String? riderUid, required String status}) async {
  if (riderUid != null) {
    await FirebaseFirestore.instance.collection('riders').doc(riderUid).update({
      'status': status,
    });
  } else {
    print("Error: riderUid is null");
  }
}
