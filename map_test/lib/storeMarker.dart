import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:map_test/main.dart';



// class CustomMarker extends Marker{
//   final String storeName = "";
//   final String phoneNumber = "";
//   CustomMarker({required super.markerId, super.position, super.width, super.height});
// }

class Place {
  final String id = "";
  final String placeName = "";
  final LatLng placePosition = const LatLng(0, 0);
  final String markerImage = "";
  final String phoneNumber = "";
  final String detailInfo = "";
}

class Restaurant implements Place {
  @override
  final String id;
  @override
  final String placeName;
  @override
  final LatLng placePosition;
  @override
  final String markerImage = "assets/icons/restaurant.png";
  @override
  final String phoneNumber;
  @override
  final String detailInfo;

  Restaurant({
    required this.id,
    required this.placeName,
    required this.placePosition,
    required this.phoneNumber,
    required this.detailInfo
});
}

class Cafe implements Place {
  @override
  final String id;
  @override
  final String placeName;
  @override
  final LatLng placePosition;
  @override
  final String markerImage = "assets/icons/cafe.png";
  @override
  final String phoneNumber;
  @override
  final String detailInfo;

  Cafe({
    required this.id,
    required this.placeName,
    required this.placePosition,
    required this.phoneNumber,
    required this.detailInfo
  });
}

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