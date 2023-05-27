import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../All Orders Screens/post_details_screen.dart';
import '../Schema/post_json.dart';

class TrackFood extends StatelessWidget {
  final PostJson post;
  const TrackFood({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Food'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home/',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Dashboard'),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Card(
                  child: ListTile(
                    title: const Text('Description of Food'),
                    subtitle: Text(post.description),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Quantity'),
                    subtitle: Text(post.quantity),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Name of Donor'),
                    subtitle: Text(post.name),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Donor's Contact Number"),
                    subtitle: Text(post.number),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        GeoPoint? currentLocation = await getCurrentLocation();
                        if (currentLocation != null) {
                          openGoogleMaps(currentLocation.latitude,
                              currentLocation.longitude, post.lat, post.long);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(fontSize: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                      ),
                      child: const Text('Track Donor Location'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final riderId =
                                FirebaseAuth.instance.currentUser?.uid;
                            updateRiderStatus(
                              riderUid: riderId,
                              status: 'pickedup',
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/ngotrackFood/',
                              (route) => false,
                              arguments: post,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            textStyle: const TextStyle(fontSize: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                          child: const Text('Confirm Pickup'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            final riderId =
                                FirebaseAuth.instance.currentUser?.uid;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "The Order is about to be Cancelled"),
                                    content: const Text(
                                        "Are you sure you want to cancel it?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Yes"),
                                        onPressed: () {
                                          updateRiderStatus(
                                            riderUid: riderId,
                                            status: 'available',
                                          );
                                          updatePostStatus(
                                            riderUid: riderId,
                                            postId: post.pid,
                                            postStatus: 1,
                                          );
                                          Navigator.of(context)
                                              .pushNamed('/home/');
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(fontSize: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                          child: const Text('Cancel Order'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openGoogleMaps(
      double lat1, double lon1, double lat2, double lon2) async {
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$lat1,$lon1&destination=$lat2,$lon2&travelmode=driving';
    String geoUrl = 'geo:$lat1,$lon1?q=$lat2,$lon2';

    if (await canLaunchUrl(Uri.parse(geoUrl))) {
      await launchUrl(Uri.parse(geoUrl));
    } else if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}
