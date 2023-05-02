import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByController extends GetxController {
  BitmapDescriptor pharm_marker = BitmapDescriptor.defaultMarker;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    get_marker_icon();
  }

  Set<Marker> generateMarkers(List locations) {
    //near pharmacy

    Set<Marker> markers = Set();

    locations.forEach((location) async {
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
