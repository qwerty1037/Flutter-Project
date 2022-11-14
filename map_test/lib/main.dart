import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naver Map',
      home: NaverMapTest(),
    );
  }
}

class NaverMapTest extends StatefulWidget {
  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}

class _NaverMapTestState extends State<NaverMapTest> {
  Completer<NaverMapController> _controller = Completer();
  List<Marker> markers = [];
  late LocationData? currentLocation;
  final MapType _mapType = MapType.Basic;

  CameraPosition initialPosition = const CameraPosition(
      target: LatLng(37.4592,126.9521), zoom: 16
  );

  void updateCurrentLocation() async {
    Location tmplocation = Location();

    tmplocation.getLocation().then(
          (location) {
        currentLocation = location;
      },
    );

    NaverMapController naverMapController = await _controller.future;

    tmplocation.onLocationChanged.listen(
          (newLoc) {
        currentLocation = newLoc;

        naverMapController.moveCamera(
          CameraUpdate.toCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }


  @override
  initState(){
    super.initState();
    updateCurrentLocation();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NaverMap Test')),
      body: NaverMap(
        onMapCreated: onMapCreated,
        mapType: _mapType,
        markers: markers,
        initialCameraPosition: initialPosition,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            Position myPosition = await _myposition();

            NaverMapController controller = await _controller.future;
            controller.moveCamera(
                CameraUpdate.toCameraPosition(
                    CameraPosition(
                        target: LatLng(myPosition.latitude, myPosition.longitude),
                        zoom: 16
                    )
                )
            );
            setState(() {});
          },
          label: const Icon(Icons.location_on_outlined)
      ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
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