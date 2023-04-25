import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../controllers/locationcontrollers.dart';
import '../../../../../utils/constants.dart';

class no_near_pharmacy_found extends StatelessWidget {
  const no_near_pharmacy_found({
    Key? key,
    required Completer<GoogleMapController> controller,
  })  : _controller = controller,
        super(key: key);

  final Completer<GoogleMapController> _controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(Get.find<Locationcontrollers>().current_lat.value,
                Get.find<Locationcontrollers>().current_long.value),
            zoom: 15.4746,
          ),
          zoomControlsEnabled: false,
          zoomGesturesEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: Center(
              child: Container(
            width: 300,
            height: 200,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FaIcon(
                  FontAwesomeIcons.locationCrosshairs,
                  size: 30,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("No pharmacy found near your location!"),
              ],
            ),
          )),
        ),
      ],
    );
  }
}
