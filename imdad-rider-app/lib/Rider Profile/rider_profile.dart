import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RiderProfile extends StatefulWidget {
  const RiderProfile({Key? key}) : super(key: key);

  @override
  RiderProfileState createState() => RiderProfileState();
}

class RiderProfileState extends State<RiderProfile> {
  final user = FirebaseAuth.instance.currentUser;

  // Stream to listen to changes in the rider document
  late Stream<DocumentSnapshot<Map<String, dynamic>>> riderStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream with the rider document
    riderStream = FirebaseFirestore.instance
        .collection('riders')
        .doc(user!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Profile'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: riderStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final riderData = snapshot.data!.data();
            if (riderData != null) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: ListTile(
                          title: const Text('Name'),
                          subtitle: Text(riderData['name'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showTextEditDialog(context, 'name',
                                  riderData['name'].toString());
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Email'),
                          subtitle: Text(riderData['email'] ?? ''),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text('Phone Number'),
                          subtitle: Text(riderData['phone_number'].toString()),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showIntEditDialog(context, 'phone_number',
                                  riderData['phone_number'].toString());
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text("Vehicle Number"),
                          subtitle: Text(riderData['vehicle_number'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showTextEditDialog(context, 'vehicle_number',
                                  riderData['vehicle_number'].toString());
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text("Vehicle Type"),
                          subtitle: Text(riderData['vehicle_type'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showDropDownEditDialog(context, 'vehicle_type');
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text("Age"),
                          subtitle: Text(riderData['age'].toString()),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showIntEditDialog(
                                  context, 'age', riderData['age'].toString());
                            },
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text("Rating"),
                          subtitle: Text(riderData['rating'].toString()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          // Placeholder or loading state while data is being fetched
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          );
        },
      ),
    );
  }
}

void _showTextEditDialog(
    BuildContext context, String fieldName, String initialValue) {
  TextEditingController textEditingController =
      TextEditingController(text: initialValue);
  final rider = FirebaseAuth.instance.currentUser;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit $fieldName'),
        content: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: 'Enter $fieldName',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              var updatedValue = textEditingController.text;
              // Update the field in the rider collection
              FirebaseFirestore.instance
                  .collection('riders')
                  .doc(rider?.uid)
                  .update({
                fieldName: updatedValue,
              });
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

void _showIntEditDialog(
    BuildContext context, String fieldName, String initialValue) {
  TextEditingController textEditingController =
      TextEditingController(text: initialValue);
  final rider = FirebaseAuth.instance.currentUser;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit $fieldName'),
        content: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: 'Enter $fieldName',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              var updatedValue = int.parse(textEditingController.text);
              // Update the field in the rider collection
              FirebaseFirestore.instance
                  .collection('riders')
                  .doc(rider?.uid)
                  .update({
                fieldName: updatedValue,
              });
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

void _showDropDownEditDialog(BuildContext context, String fieldName) {
  String? _vehicleType;
  final rider = FirebaseAuth.instance.currentUser;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit $fieldName'),
        content: DropdownButtonFormField<String>(
          hint: const Text('Vehicle Type'),
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
            prefixIcon: Icon(Icons.fire_truck),
            labelText: "Vehicle type",
            hintText: 'Choose your vehicle',
            border: OutlineInputBorder(),
          ),
          value: _vehicleType,
          onChanged: (String? value) {
            _vehicleType = value;
          },
          items: const [
            DropdownMenuItem(
              value: 'Bike',
              child: Text('Bike'),
            ),
            DropdownMenuItem(
              value: 'Car',
              child: Text('Car'),
            ),
            DropdownMenuItem(
              value: 'Suzuki',
              child: Text('Suzuki'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              var updatedValue = _vehicleType;
              // Update the field in the rider collection
              FirebaseFirestore.instance
                  .collection('riders')
                  .doc(rider?.uid)
                  .update({
                fieldName: updatedValue,
              });
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
