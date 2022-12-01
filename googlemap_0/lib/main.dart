import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap_0/CustomMarker.dart';
import 'package:googlemap_0/MarkerData.dart';
import 'package:location/location.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<CustomMarker> _markers = MarkerData.myMarkers();
  bool buttonBool = false;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');

    controller.setMapStyle(value);
    _controller.complete(controller);

    setState(() {
      // _markers.add(Marker(
      //     markerId: MarkerId("301"),
      //     draggable: true,
      //     onTap: () => print("Marker!"),
      //     position: LatLng(37.4498, 126.9525)));
      // _markers.add(Marker(
      //     markerId: MarkerId("gwanjung"),
      //     draggable: true,
      //     onTap: () => print("Marker!"),
      //     position: LatLng(37.4592, 126.9521)));
      // _markers.add(Marker(
      //     markerId: MarkerId("sthwest"),
      //     draggable: true,
      //     onTap: () => print("Marker!"),
      //     position: LatLng(37.4467, 126.9473)));
      // _markers.add(Marker(
      //     markerId: MarkerId("ntheast"),
      //     draggable: true,
      //     onTap: () => print("Marker!"),
      //     position: LatLng(37.4697, 126.9613)));
    });
  }

  void initState(){
    locationPermission();
    super.initState();
    for (var marker in _markers){
      marker.createImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SNU Maps'),
          backgroundColor: Colors.blue[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.4592, 126.9521),
            zoom: 17,
          ),
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: const LatLng(37.4467, 126.9473),
              northeast: const  LatLng(37.4697, 126.9613),
            )
          ),
          minMaxZoomPreference: const MinMaxZoomPreference(15, 18),
          markers: _markers.toSet(),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Icon(Icons.location_on_outlined),
          onPressed: ()async{
            buttonBool = !buttonBool;
            late LocationData currentLocation;
            Location tmplocation = Location();

            print(buttonBool);
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

            tmplocation.getLocation().then(
                  (location) {
                currentLocation = location;
              },
            );

            /*추후 필요하면 listen을 cancel로 취소하는 개선 필요!! 계속 listen이 되고 있다*/
            /* https://software-creator.tistory.com/9 침고 */
            tmplocation.onLocationChanged.listen(
                  (newLoc) async {
                currentLocation = newLoc;

                GoogleMapController googleMapController =
                await _controller.future;

                if (buttonBool){
                  googleMapController.moveCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        zoom: 16,
                        target: LatLng(
                          newLoc.latitude!,
                          newLoc.longitude!,
                        ),
                      ),
                    ),
                  );
                }
                setState(() {});
              },
            );
          }
        ),
      ),
    );
  }

  void locationPermission() async{
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}