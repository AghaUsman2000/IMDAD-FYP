import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Data/JSON/org_json.dart';
import '../../Data/JSON/post_json.dart';
import '../../Data/JSON/user_json.dart';

class RiderScreen extends StatefulWidget {
  final PostJson post;

  const RiderScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<RiderScreen> createState() => _RiderScreenState();
}

class _RiderScreenState extends State<RiderScreen> {
  OrgJson? _orgLocation;

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
        title: const Text('Rider Information'),
        backgroundColor: const Color(0xFF004643),
      ),
      body: _orgLocation == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('riders')
                  .doc(widget.post.riderUid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                          target: LatLng(_orgLocation!.lat, _orgLocation!.long),
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('org_location'),
                            position:
                                LatLng(_orgLocation!.lat, _orgLocation!.long),
                            infoWindow: InfoWindow(
                                title: _orgLocation!.name,
                                snippet: _orgLocation!.description),
                          ),
                          Marker(
                            markerId: const MarkerId('post_location'),
                            position: LatLng(widget.post.lat, widget.post.long),
                            infoWindow: InfoWindow(
                                title: widget.post.title,
                                snippet: widget.post.description),
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
                        subtitle:
                            Text('Age: ${data['age'] ?? 'Not specified'}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Phone Number'),
                        subtitle:
                            Text('${data['phone_number'] ?? 'Not specified'}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Vehicle Type'),
                        subtitle:
                            Text('${data['vehicle_type'] ?? 'Not specified'}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Donor's Name"),
                        subtitle: Text(widget.post.name),
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
                        title: const Text("Organization's Name"),
                        subtitle: Text(_orgLocation!.name),
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
      print(orgQuery);
      return OrgJson.fromJson(orgDoc.data() as Map<String, dynamic>);
    } else {
      print(orgQuery);
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
