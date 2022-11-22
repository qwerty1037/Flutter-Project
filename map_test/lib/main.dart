import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'storeMarker.dart';
List<Marker> testMarker = TestData().returnMarkers();


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
  OverlayImage? markerIcon;
  final MapType _mapType = MapType.Basic;

  CameraPosition initialPosition = const CameraPosition(
      target: LatLng(37.4592,126.9521), zoom: 16
  );

  void initState(){
    addMarkerImage();
    super.initState();
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


    markers.addAll(testMarker);
  }

  void addMarkerImage() async {
    OverlayImage.fromAssetImage(assetName: 'assets/icons/32bit.png').then(
            (icon){
              markerIcon = icon;
              setState(() {
              });
    });
  }

  void markerDisplay(){
    markers.clear();
    //~~~~~

    setState(() {
    });

  }

}