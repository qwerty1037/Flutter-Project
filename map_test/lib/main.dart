import 'dart:async';
import 'package:flutter/material.dart';
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
  OverlayImage? markerIcon;
  final MapType _mapType = MapType.Basic;

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(37.4592, 126.9521), zoom: 16);

  void initState() {
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
    );
  }

  void onMapCreated(NaverMapController controller) async {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);

    markers.add(Marker(
      markerId: "1",
      position: LatLng(37.4592, 126.9521),
      icon: markerIcon,
      width: 45,
      height: 45
    ));
  }

  void addMarkerImage() async {
    OverlayImage.fromAssetImage(assetName: 'assets/icons/restaurant.png')
        .then((icon) {
      markerIcon = icon;
      setState(() {});
    });
  }
}
