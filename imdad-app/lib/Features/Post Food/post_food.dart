import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/Features/Post%20Food/post_food_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../Data/JSON/user_json.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class PostFood extends StatefulWidget {
  const PostFood({Key? key}) : super(key: key);
  @override
  State<PostFood> createState() => _PostFoodState();
}

class _PostFoodState extends State<PostFood> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController quantity = TextEditingController();
  String dropdownValue = 'Ready Made Food';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  bool value = false;

  File? pickedImage1;
  File? pickedImage2;
  File? pickedImage3;
  String? val;

  List<UserJson> users = [];

  void imagePickerOption(File? image) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera, image);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery, image);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType, File? image) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);
      if (image == pickedImage1) {
        setState(() {
          pickedImage1 = tempImage;
        });
      } else if (image == pickedImage2) {
        setState(() {
          pickedImage2 = tempImage;
        });
      } else if (image == pickedImage3) {
        setState(() {
          pickedImage3 = tempImage;
        });
      }

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = Path.basename(imageFile.path);
      Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(imageFile);

      // Get the download URL of the uploaded file
      String imageUrl = await (await uploadTask).ref.getDownloadURL();

      return imageUrl;
    } catch (error) {
      print('Error uploading image: $error');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Post Food'),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF004643),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'About food',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
              const SizedBox(
                height: 15,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Title refers to the name of the food like chicken biryani, achari handi, etc.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFABD1C6),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white /*const Color(0xFF001E1D)*/,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Enter title',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "A description about what it is, what is in the food you’re posting. Any important message you want the customers to know will also come here",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFABD1C6),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: description,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white /*const Color(0xFF001E1D)*/,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'How much do have? Enter the value and then in the field below select the quantity',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFABD1C6),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: quantity,
                maxLength: 2,
                validator: (value) {
                  if (value!.length > 2) {
                    return 'Maximum length exceeded';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white /*const Color(0xFF001E1D)*/,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  hintStyle: const TextStyle(color: Color(0xFFABD1C6)),
                  hintText: 'Quantity',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '  Category',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )),
              const SizedBox(
                height: 5,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                //dropdownColor: Colors.greenAccent,
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>[
                  'Ready Made Food',
                  'Fruits',
                  'General',
                  'Others'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      // style: TextStyle(fontSize: 20),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  stackContainer(image: pickedImage1),
                  stackContainer(image: pickedImage2),
                  stackContainer(image: pickedImage3),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevents dismissing the dialog by tapping outside
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              );
            },
          );
          try {
            Position position = await _determinePosition();
            context.read<PostFoodProvider>().getUserDetails(user.uid);
            users = context.read<PostFoodProvider>().list;

            String name = users[users.length - 1].name;
            String number = users[users.length - 1].number;

            String imageUrl1 = '';
            String imageUrl2 = '';
            String imageUrl3 = '';

            if (pickedImage1 != null) {
              imageUrl1 = await uploadImageToFirebase(pickedImage1!);
            }
            if (pickedImage2 != null) {
              imageUrl2 = await uploadImageToFirebase(pickedImage2!);
            }
            if (pickedImage3 != null) {
              imageUrl3 = await uploadImageToFirebase(pickedImage3!);
            }

            Provider.of<PostFoodProvider>(context, listen: false).addposts(
              title.text,
              description.text,
              quantity.text,
              user.uid,
              position.latitude,
              position.longitude,
              name,
              number,
              imageUrl1,
              imageUrl2,
              imageUrl3,
            );
            Navigator.of(context).pop();
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text('Post Added Successfully!'),
                );
              },
            );
          } catch (error) {
            Navigator.of(context).pop();
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content:
                      const Text('A Network has occured, please try again'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        label: const Text(
          'Post',
          style:
              TextStyle(color: Color(0xFF004643), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF9BC60),
      ),
    );
  }

  stackContainer({File? image}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo, width: 5),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
          ),
          child: ClipOval(
            child: image != null
                ? Image.file(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    'https://pixsector.com/cache/d01b7e30/av7801257c459e42a24b5.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: IconButton(
            onPressed: () {
              imagePickerOption(image);
            },
            icon: const Icon(
              Icons.add_a_photo_outlined,
              color: Colors.blue,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }
}
