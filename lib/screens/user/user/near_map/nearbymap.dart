import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/locationcontrollers.dart';
import 'package:hakimea/controllers/user_controllers/nearbycontrollers.dart';
import 'package:hakimea/screens/user/user/near_map/widget/near_pharmacy_card.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/cool_loading.dart';

import 'widget/no_nearpharmacy.dart';

class NearByMap extends StatefulWidget {
  const NearByMap({Key? key}) : super(key: key);
  @override
  State<NearByMap> createState() => _NearByMapState();
}

class _NearByMapState extends State<NearByMap> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.primcolor,
          title: const Text(
            "Pharmacy near you",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const FaIcon(
                  FontAwesomeIcons.refresh,
                  color: Colors.white,
                ))
          ],
        ),
        body:Stack(
          children: [
            Container(
              width: Get.width,
              height: 60,
              color: Constants.primcolor,
            ),
            Query(
              options:
              QueryOptions(document: gql(Myquery.near_pharmacys), variables: {
                "latitude": Get.find<Locationcontrollers>().current_lat.value,
                "longitude": Get.find<Locationcontrollers>().current_long.value,
                "radius": 20
              }),
              builder: (result, {fetchMore, refetch}) {
                if (result.hasException) {
                  print(result.exception.toString());
                }
                if (result.isLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      cool_loding(),
                      Text(
                        "searching pharmacy near you..",
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  );
                }
                // get near pharmacys
                List? near_pharmacy = result.data!["nearByPharmacy"];

                if (near_pharmacy!.isEmpty) {
                  return no_near_pharmacy_found(controller: _controller);
                }
                return ClipRRect(
                  borderRadius:const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)
                  ),
                  child: Stack(
                    children: [
                      // map
                      Obx(() => GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          bearing: 1.0,
                          tilt: 0.5,
                          target: LatLng(
                              Get.find<Locationcontrollers>().current_lat.value,
                              Get.find<Locationcontrollers>().current_long.value),
                          zoom: 17.4746,
                        ),
                        markers: Get.find<NearByController>()
                            .generateMarkers(near_pharmacy),
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                        myLocationButtonEnabled: true,
                        compassEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          Get.find<NearByController>().get_marker_icon();
                        },
                      )),

                      // pharmacy
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            width: Get.width,
                            height: 250,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: near_pharmacy.length,
                              itemBuilder: (context, index) {
                                return near_pharmacy_card(
                                  phlat: near_pharmacy[index]["address"]["latitude"],
                                  phlong: near_pharmacy[index]["address"]
                                  ["longitude"],
                                  id: near_pharmacy[index]["id"],
                                  image: near_pharmacy[index]["logo_image"]["url"],
                                  location: near_pharmacy[index]["address"]
                                  ["location"],
                                  name: near_pharmacy[index]["name"],
                                  open_time: near_pharmacy[index]["open_time"],
                                  close_time: near_pharmacy[index]["open_time"],
                                  phone: near_pharmacy[index]["phone_number"],
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        )
       
    );
  }
}
