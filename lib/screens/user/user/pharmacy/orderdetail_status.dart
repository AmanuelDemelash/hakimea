import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/subscriptions.dart';
import 'package:hakimea/controllers/locationcontrollers.dart';
import 'package:hakimea/controllers/user_controllers/ordercontroller.dart';
import 'package:hakimea/screens/user/user/pharmacy/widget/order_detail_card.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/cool_loading.dart';

class OrderDetailStatus extends StatelessWidget {
  int id = Get.arguments;
  OrderDetailStatus({super.key});

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.whitesmoke,
          title: const Text(
            "Order Status",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
              )),
        ),
        body:
        Subscription(
          options: SubscriptionOptions(
              document: gql(MySubscription.upcoming_order_detail),
              variables: {"id": id}),
          builder: (result) {
            if (result.hasException) {
              print(result.exception.toString());
            }
            if (result.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  cool_loding(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Please wait!")
                ],
              );
            }
            Map<String, dynamic> order = result.data!["orders_by_pk"];


            return Stack(
              children: [
                SizedBox(
                  width: Get.width,
                  height: Get.width,
                ),
                // map
                SizedBox(
                  child:
                      Obx(() =>GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                target: LatLng(
                Get.find<Locationcontrollers>().current_lat.value,
                Get.find<Locationcontrollers>().current_long.value),
                zoom: 17.4746,
                ),
                compassEnabled: false,
                polylines:  {
                  Polyline(
                      polylineId: const PolylineId("route"),
                      points:Get.find<OrderController>().polylinecordinates.value,
                      color: Constants.primcolor,
                      width: 5)
                },
                markers:{
                  //pharmacy
                  Marker(
                      markerId:const MarkerId("pharma"),
                      icon:Get.find<OrderController>().pharm_marker,
                      infoWindow: const InfoWindow(
                          title: "pharmacy"
                      ),
                      position:LatLng(
                          order["pharmacy"]["address"]["latitude"],
                          order["pharmacy"]["address"]["longitude"])),
                  // user
                  Marker(
                      markerId:const MarkerId("user"),
                      icon:Get.find<OrderController>().user_marker,
                      position:LatLng(
                          Get.find<Locationcontrollers>().current_lat.value,
                          Get.find<Locationcontrollers>()
                              .current_long
                              .value)),
                  order["deliverer_id"]==null?const Marker(markerId: MarkerId("delivery")):
                  Marker(
                      markerId:const MarkerId("delivery"),
                      icon:Get.find<OrderController>().delivery_marker,
                      position: LatLng(
                          order["deliverer"]["address"]["latitude"],
                          order["deliverer"]["address"]["longitude"]))
                },
                onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                },
            ),
                      )
                  
                ),
                // detail
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: order_detail_card(
                      delivery: order["deliverer"] == null
                          ? {}
                          : {
                              "name": order["deliverer"]["full_name"],
                              "image": order["deliverer"]["image"]["url"],
                              "phone": order["deliverer"]["phone_number"]
                            },
                      status: order["status"].toString(),
                    )
                )
              ],
            );
          },
        ));
  }
}
