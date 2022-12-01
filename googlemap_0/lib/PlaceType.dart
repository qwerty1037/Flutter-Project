import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceType {
  final MarkerId id = MarkerId("");
  final String placeName = "";
  final String markerImage = "";
  final LatLng location = const LatLng(0, 0);
  final String detailInfo = "";
}

class Restaurant implements PlaceType {
  @override
  final MarkerId id;
  @override
  final String placeName;
  @override
  final String markerImage = "assets/icons/restaurant.png";
  @override
  final LatLng location;
  @override
  final String detailInfo;

  Restaurant({
    required this.id,
    required this.placeName,
    required this.location,
    required this.detailInfo,
});
}

class Cafe implements PlaceType {
  @override
  final MarkerId id;
  @override
  final String placeName;
  @override
  final String markerImage = "assets/icons/cafe.png";
  @override
  final LatLng location;
  @override
  final String detailInfo;

  Cafe({
    required this.id,
    required this.placeName,
    required this.location,
    required this.detailInfo,
  });
}