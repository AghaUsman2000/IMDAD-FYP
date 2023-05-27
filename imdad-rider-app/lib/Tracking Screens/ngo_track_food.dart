import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../All Orders Screens/post_details_screen.dart';
import '../Schema/org_json.dart';
import '../Schema/post_json.dart';
import '../Schema/user_json.dart';
import '../Startup Screens/timer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NgoTrackFood extends StatefulWidget {
  final PostJson post;
  const NgoTrackFood({Key? key, required this.post}) : super(key: key);

  @override
  State<NgoTrackFood> createState() => _NgoTrackFoodState();
}

class _NgoTrackFoodState extends State<NgoTrackFood> {
  OrgJson? _orgLocation;
  late final TimerClass _timer = TimerClass();

  @override
  void initState() {
    super.initState();
    _fetchOrgLocation();
  }

  void _fetchOrgLocation() async {
    OrgJson? orgLocation = await getOrganizationLocation(widget.post.nid);
    setState(() {
      _orgLocation = orgLocation;
    });
  }

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
                const SizedBox(height: 50),
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
                    title: const Text("NGO Representative's Name"),
                    subtitle: Text(widget.post.nname),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("NGO's Contact Number"),
                    subtitle: Text(widget.post.nnumber),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text("Donor's Name"),
                    subtitle: Text(widget.post.name),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        openGoogleMaps(
                          widget.post.lat,
                          widget.post.long,
                          _orgLocation!.lat,
                          _orgLocation!.long,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        textStyle: const TextStyle(fontSize: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                      ),
                      child: const Text('Track NGO Location'),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final riderId =
                              FirebaseAuth.instance.currentUser?.uid;

                          updatePostStatus(
                            riderUid: riderId,
                            postId: widget.post.pid,
                            postStatus: 2,
                          );
                          _timer.stopLocationUpdates();

                          updateRiderStatus(
                            riderUid: riderId,
                            status: 'completed',
                          );

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home/',
                            (route) => false,
                            arguments: widget.post,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(fontSize: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                        ),
                        child: const Text('Confirm Order as Delivered'),
                      ),
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

Future<OrgJson?> getOrganizationLocation(String nid) async {
  try {
    // Fetch user document from users collection using nid
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(nid).get();
    UserJson user = UserJson.fromJson(userDoc.data() as Map<String, dynamic>);

    // Fetch organization document from organizations collection using organization name
    QuerySnapshot orgQuery = await FirebaseFirestore.instance
        .collection('organizations')
        .where('name', isEqualTo: user.organisation)
        .get();

    if (orgQuery.docs.isNotEmpty) {
      // If organization is found, return the OrgJson object
      DocumentSnapshot orgDoc = orgQuery.docs.first;
      return OrgJson.fromJson(orgDoc.data() as Map<String, dynamic>);
    } else {
      // If organization is not found, return null
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
