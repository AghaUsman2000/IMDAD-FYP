import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Domain/org_entity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:provider/provider.dart';

import 'home_donor_provider.dart';

class HomeDonor extends StatefulWidget {
  @override
  State<HomeDonor> createState() => HomeDonorState();
}

class HomeDonorState extends State<HomeDonor> {
  late String lat;
  late String long;

  Completer<GoogleMapController> _controller = Completer();
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Set<Marker> _markers = {};
  List<OrgEntity> list = [];

  @override
  void initState() {

    super.initState();


    context.read<HomeDonorProvider>().fetchOrgs();



    Future.delayed(Duration(seconds: 1), () {

      list = context.read<HomeDonorProvider>().list;
      print(context.read<HomeDonorProvider>().list.length);
      loadData();

    });
  }

  Future<Position> _getCurrent() async {
    bool sE = await Geolocator.isLocationServiceEnabled();
    if (!sE) {
      return Future.error('Disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  loadData() {

    BitmapDescriptor customIcon;
     customIcon = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(20, 40)),
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
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 300,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(e.image),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                style: TextStyle(fontWeight: FontWeight.bold),
                                e.name,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Text(
                          e.description,
                          maxLines: 2,
                        ),
                      ),
                    ],
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
            height: 200,
            width: 300,
            offset: 35,
          ),
        ], //<Widget>[]
      ),
    );
  }
}
