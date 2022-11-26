import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:map_test/PlaceType.dart';
import 'package:map_test/CustomMarker.dart';

class MarkerData {
  static final List<PlaceType> restaurants = [
    Cafe(
        id: "1",
        placeName: "느티나무",
        location: const LatLng(37.4591, 126.9519),
        detailInfo: "중앙도서관 카페"),
    Restaurant(
        id: "2",
        placeName: "곻대 간이식당",
        location: const LatLng(37.4572, 126.9508),
        detailInfo: "공대 간이식당"),
  ];

  static List<CustomMarker> myMarkers() {
    List<CustomMarker> list = [];
    for (var pt in MarkerData.restaurants) {
      list.add(CustomMarker.fromMyPlace(pt));
    }
    return list;
  }
}