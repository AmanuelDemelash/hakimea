import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByController extends GetxController {
  BitmapDescriptor pharm_marker = BitmapDescriptor.defaultMarker;

  Set<Marker> generateMarkers(List locations) {
    //near pharmacy
    get_marker_icon();
    Set<Marker> markers = Set();

    locations.forEach((location) async {
      get_marker_icon();
      markers.add(
        Marker(
            markerId: MarkerId("${location["id"]}"),
            icon: pharm_marker,
            position: LatLng(
              location["address"]["latitude"],
              location["address"]["longitude"],
            )),
      );
    });

    return markers;
  }

  Future<BitmapDescriptor> get_marker_icon() async {
    return BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/marker.png")
        .then((value) => pharm_marker = value);
  }
}
