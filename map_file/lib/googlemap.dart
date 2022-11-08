import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:snu_lecture_map/menuCrawling.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class googlemapscreen extends StatefulWidget {
  const googlemapscreen({Key? key}) : super(key: key);

  @override
  State<googlemapscreen> createState() => _googlemapscreenState();
}

class _googlemapscreenState extends State<googlemapscreen> {
  late final Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = {};

  final LatLng _center = const LatLng(37.4592, 126.9521);

  void _onMapCreated(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
    mapController.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appbarHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appbarHeight),
        child: AppBar(
          title: Text(
            "지도",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(),
          actions: [
            IconButton(
              icon: Icon(Icons.restaurant_menu_sharp),
              onPressed: () {
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
                      child: Text(
                        "월요일",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "화요일",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 17.0,
        ),
        markers: markers,
        zoomControlsEnabled: false,
        cameraTargetBounds: CameraTargetBounds(LatLngBounds(
          southwest: LatLng(37.4467, 126.9473),
          northeast: LatLng(37.4697, 126.9613),
        )),
        minMaxZoomPreference: const MinMaxZoomPreference(15, 18),
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            Position myposition = await _myposition();

            GoogleMapController controller = await mapController.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(myposition.latitude, myposition.longitude), zoom: 17)
                )
            );

            markers.clear();

            markers.add(
                Marker(markerId: MarkerId('currentLocation'),
                    position: LatLng(myposition.latitude, myposition.longitude))
            );
            setState(() {});
          },
          label: const Icon(Icons.location_on_outlined)
      ),
    );
  }
}

Future<Position> _myposition() async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if(!serviceEnabled) {
    return Future.error("Location services are disabled");
  }

  permission = await Geolocator.checkPermission();

  if(permission  == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if(permission == LocationPermission.denied) {
      return Future.error("Location Permission denied");
    }
  }

  if(permission == LocationPermission.deniedForever) {
    return Future.error("Location Permission permanently denied");
  }

  Position position = await Geolocator.getCurrentPosition();

  return position;
}
