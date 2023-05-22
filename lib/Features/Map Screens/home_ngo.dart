import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Domain/org_entity.dart';
import 'package:flutterdemo/Features/Map%20Screens/home_ngo_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:provider/provider.dart';

import '../../Data/JSON/post_json.dart';
import '../../Domain/post_entity.dart';
import 'home_donor_provider.dart';

class HomeNgo extends StatefulWidget {
  @override
  State<HomeNgo> createState() => HomeNgoState();
}

class HomeNgoState extends State<HomeNgo> {


  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  Set<Marker> _markers = {};
  List<PostJson> list = [];

  @override
  void initState() {
    super.initState();

    context.read<HomeNgoProvider>().fetchPosts();

    Future.delayed(Duration(seconds: 1), () {
      list = context.read<HomeNgoProvider>().list;
      print('Length:');
      print(context.read<HomeNgoProvider>().list.length);
      loadData();
    });
  }

  loadData() {

    BitmapDescriptor customIcon;
    customIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueYellow,
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 200)),
        'assets/images/locationn.bmp')
        .then((d) {
      customIcon = d;

      for (var e in list) {
        _markers.add(Marker(
            markerId: MarkerId(e.long.toString()),
            position: LatLng(e.lat, e.long),
            icon: customIcon,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  // width: 250,
                  // height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20, right: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 250,
                          child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            e.title,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                        Text(
                          e.description,
                          maxLines: 4,
                        ),
                        SizedBox(height: 4),
                        Text('Quantity ' + e.quantity),
                        SizedBox(height: 8),
                        Text('Posted by ' + e.name),
                        Text(e.number)

                      ],
                    ),
                  ),
                ),
                LatLng(e.lat, e.long),
              );
            }));
      }

    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Container//Container
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(24.860966, 66.990501), zoom: 11),
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
                onMapCreated: (GoogleMapController controller) async {
                  _customInfoWindowController.googleMapController = controller;
                },
                markers: _markers,
              )),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 170,
            width: 300,
            offset: 35,
          ),
        ], //<Widget>[]
      ),
    );
  }
}
