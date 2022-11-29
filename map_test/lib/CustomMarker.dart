import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:map_test/PlaceType.dart';

class CustomMarker extends Marker {
  final PlaceType place;

  CustomMarker({
    required this.place,
    required super.position,
    super.width = 20,
    super.height = 20
  }) : super(markerId: place.id,
      captionText: place.placeName);

  factory CustomMarker.fromMyPlace(PlaceType place) =>
      CustomMarker(place: place, position: place.location);

  Future<void> createImage() async{
    icon = await OverlayImage.fromAssetImage(assetName: place.markerImage);
  }
}