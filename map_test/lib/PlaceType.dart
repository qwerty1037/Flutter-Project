import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:flutter/material.dart';

class PlaceType {
  final String id = "";
  final String placeName = "";
  final String markerImage = "";
  final LatLng location = const LatLng(0, 0);
  final String detailInfo = "";
  final Color markerColor = Colors.black;
}

class Restaurant implements PlaceType {
  @override
  final String id;
  @override
  final String placeName;
  @override
  final String markerImage = "assets/icons/restaurant.png";
  @override
  final LatLng location;
  @override
  final String detailInfo;
  @override
  final Color markerColor = Colors.red;

  Restaurant({
    required this.id,
    required this.placeName,
    required this.location,
    required this.detailInfo,
});
}

class Cafe implements PlaceType {
  @override
  final String id;
  @override
  final String placeName;
  @override
  final String markerImage = "assets/icons/cafe.png";
  @override
  final LatLng location;
  @override
  final String detailInfo;
  @override
  final Color markerColor = Colors.orange;

  Cafe({
    required this.id,
    required this.placeName,
    required this.location,
    required this.detailInfo,
  });
}