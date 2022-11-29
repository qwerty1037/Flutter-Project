import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'MarkerData.dart';
import 'package:map_test/CustomMarker.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naver Map',
      home: NaverMapTest(),
    );
  }
}

class NaverMapTest extends StatefulWidget {
  const NaverMapTest({super.key});

  @override
  _NaverMapTestState createState() => _NaverMapTestState();
}

class _NaverMapTestState extends State<NaverMapTest> {
  Completer<NaverMapController> _controller = Completer();
  final MapType _mapType = MapType.Basic;
  List<CustomMarker> markers = MarkerData.myMarkers();

  CameraPosition initialPosition = const CameraPosition(
      target: LatLng(37.4592,126.9521), zoom: 16
  );

  @override
  void initState(){
    super.initState();
    for (var marker in markers) {
      marker.createImage();
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('NaverMap Test')),
      body: NaverMap(
        locationButtonEnable: true,
        onMapCreated: onMapCreated,
        mapType: _mapType,
        markers: markers,
        initialCameraPosition: initialPosition,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){markerDisplay();},
      ),
    );
  }

  void onMapCreated(NaverMapController controller) async {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  void markerDisplay(){
    markers.clear();
    // CustomMarker.changeImage;
    setState(() {
    });

  }

}
