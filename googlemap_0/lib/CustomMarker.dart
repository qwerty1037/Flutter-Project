import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'PlaceType.dart';

class CustomMarker extends Marker {
  final PlaceType place;

  CustomMarker({
    required this.place,
    required super.position,
  }) : super(markerId: place.id);

  factory CustomMarker.fromMyPlace(PlaceType place) =>
      CustomMarker(place: place, position: place.location);

  Future<void> createImage() async{
    icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, place.markerImage);
  }
}