import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

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
  final MapType _mapType = MapType.Basic;
  bool buttonBool = false;

  CameraPosition initialPosition = const CameraPosition(
      target: LatLng(37.4592,126.9521), zoom: 16
  );

  @override
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
            buttonBool = !buttonBool;
            late LocationData currentLocation;
            Location tmplocation = Location();

            ///테스트 용도!!!!!!!!!!!!!!!!!!
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            print(buttonBool);
            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

            tmplocation.getLocation().then(
                  (location) {
                currentLocation = location;
              },
            );

              tmplocation.onLocationChanged.listen(
                (newLoc) async {
                  currentLocation = newLoc;

                  NaverMapController naverMapController =
                      await _controller.future;

                  if (buttonBool){
                    naverMapController.moveCamera(
                      CameraUpdate.toCameraPosition(
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
          },
          label: const Icon(Icons.location_on_outlined)
      ),
    );
  }

  void onMapCreated(NaverMapController controller) async {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);

    // markers.add(
    //   Marker(
    //       markerId: "1",
    //       position: LatLng(37.4506, 126.9534),
    //       icon: _image,
    //   )
    // );
  }
}