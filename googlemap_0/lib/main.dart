import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Marker> _markers = [];

  Future<void> _onMapCreated(GoogleMapController controller) async {

    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("301"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(37.4498, 126.9525)));
      _markers.add(Marker(
          markerId: MarkerId("gwanjung"),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(37.4592, 126.9521)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.4592, 126.9521),
            zoom: 17,
          ),
          markers: _markers.toSet(),
        ),
      ),
    );
  }
}