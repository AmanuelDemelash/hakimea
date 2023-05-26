import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../apiservice/mymutation.dart';
import '../../../../../controllers/locationcontrollers.dart';
import '../../../../../controllers/splashcontroller.dart';
import '../../../../../controllers/user_controllers/prescriptioncontroller.dart';
import '../../../../../widgets/cool_loading.dart';

class OrderPrescriptin extends StatelessWidget {
  Map<String, dynamic> data;

  OrderPrescriptin({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(Mymutation.orderRecomendation),
          onError: (error) {
            Get.find<PrescriptionController>().isOrderRecom.value = false;
          },
          onCompleted: (data) {
            if (data!.isNotEmpty) {
              Get.find<PrescriptionController>().isOrderRecom.value = false;
            }
          },
        ),
        builder: (runMutation, result) {
          if (result!.hasException) {
            print(result.exception);
          }
          if (result!.isLoading) {
            Get.find<PrescriptionController>().isOrderRecom.value = true;
            Get.snackbar("Success", "you successfully order your prescription",
                snackPosition: SnackPosition.TOP,
                icon: const FaIcon(
                  FontAwesomeIcons.print,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
                colorText: Colors.white);
            Get.offAllNamed("/mainhomepage");
          }

          return Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
              onPressed: () async {
                runMutation({
                  "city":
                  Get.find<Locationcontrollers>().city.value,
                  "defee": data["defee"],
                  "totcost": data["totcost"],
                  "distance": data["distance"],
                  "location": Get.find<Locationcontrollers>()
                      .address
                      .value,
                  "lat": Get.find<Locationcontrollers>()
                      .current_lat
                      .value,
                  "lon": Get.find<Locationcontrollers>()
                      .current_long
                      .value,
                  "uid": Get.find<SplashController>()
                      .prefs
                      .getInt("id"),
                  "pid": data["pid"],
                  "dprecid": data["dprecid"]
                });
                // Get.dialog(
                //     AlertDialog(
                //       actionsOverflowAlignment: OverflowBarAlignment.center,
                //       titleTextStyle:
                //           const TextStyle(fontSize: 20, color: Colors.black),
                //       title: const Text("Do you want to order?"),
                //       content: SizedBox(
                //         height: 100,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Obx(
                //               () => Get.find<PrescriptionController>()
                //                           .isOrderRecom
                //                           .value ==
                //                       true
                //                   ? cool_loding()
                //                   : Text(
                //                       "order your prescription to ${data["name"]}",
                //                       textAlign: TextAlign.center,
                //                     ),
                //             ),
                //             const SizedBox(
                //               height: 30,
                //             )
                //           ],
                //         ),
                //       ),
                //       actions: [
                //         TextButton(
                //             onPressed: () => Get.back(),
                //             child: const Text(
                //               "Cancel",
                //               style: TextStyle(color: Colors.red),
                //             )),
                //         TextButton(
                //             onPressed: () {
                //
                //             },
                //             child: const Text("Order"))
                //       ],
                //     ),
                //     barrierDismissible: false);
              },
              child:Get.find<PrescriptionController>()
                  .isOrderRecom
                  .value ==
                  true
                  ? const cool_loding(): const Text(
                "Order",
                style: TextStyle(color: Colors.white),
              )));
        });
  }
}
