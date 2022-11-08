import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'dart:async';

import 'package:snu_lecture_map/search.dart';
import 'package:snu_lecture_map/timetable.dart';
import 'package:snu_lecture_map/buildingdata.dart';
import 'package:snu_lecture_map/setting.dart';
import 'package:snu_lecture_map/menuCrawling.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/animation.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';


class googlemapscreen extends StatefulWidget {
  const googlemapscreen({Key? key}) : super(key: key);

  @override
  State<googlemapscreen> createState() => _googlemapscreenState();
}

class _googlemapscreenState extends State<googlemapscreen> {

  late Completer<GoogleMapController> _mapController = Completer();
  final LatLng _center = const LatLng(37.4592, 126.9521);
  LocationData? currentlocation;
  BitmapDescriptor myLocIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation(){
    Location myLocation = Location();

    myLocation.getLocation().then(
        (myLocation){
      currentlocation = myLocation;
      }
    );

    myLocation.onLocationChanged.listen((newLoc) {
      currentlocation = newLoc;

      setState(() { });
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  void setCustomMarkerIcon(){
    // BitmapDescriptor.fromAssetImage(configuration, assetName);
  }

  void initState(){
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double appbarHeight = screenHeight * 0.07;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appbarHeight),
          child: AppBar(
            title: Text("지도", style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(),
            actions: [
              IconButton(
                icon: Icon(Icons.restaurant_menu_sharp),
                onPressed: (){
                  getMenuInfo();
                },
              )
            ],
          ),
        ),
        drawer: Drawer(
          elevation: 10,
          child: ListView(
            children: [
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "요일별 동선",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("월요일",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("화요일",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
        body: currentlocation == null
            ? const Center(child: Text("Loading"))
            : GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.0,
          ),
          cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                southwest: LatLng(37.4467, 126.9473),
                northeast: LatLng(37.4697, 126.9613),
              )
          ),
          minMaxZoomPreference: const MinMaxZoomPreference(15, 18),
          markers: {
            Marker(
              markerId: const MarkerId("currentLocation"),
              position: LatLng(currentlocation!.latitude!, currentlocation!.longitude!),
            ),
          }
          )
    );
  }
}