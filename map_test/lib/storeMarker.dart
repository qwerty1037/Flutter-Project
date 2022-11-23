import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:map_test/main.dart';



// class CustomMarker extends Marker{
//   final String storeName = "";
//   final String phoneNumber = "";
//   CustomMarker({required super.markerId, super.position, super.width, super.height});
// }


class TestData {
  List<Marker> testMarker= [
    Marker(
      markerId: "1",
      position: const LatLng(37.4592,126.9521),
      icon: null,
      // onMarkerTab: function
    ),
    Marker(
      markerId: "2",
      position: const LatLng(37.4595,126.9521),
      icon: null,
    ),
  ];

  List<Marker> returnMarkers(){
    return this.testMarker;
  }
}