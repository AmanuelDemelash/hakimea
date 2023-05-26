import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/buttonspinner.dart';

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
    Get.find<PrescriptionController>()
        .isOrderRecom
        .value = false;
    },
    onCompleted: (data) {
    if (data!.isNotEmpty) {
    Get.find<PrescriptionController>()
        .isOrderRecom
        .value = false;
    Get.snackbar("Success",
    "you successfully order your prescription",
    snackPosition: SnackPosition.TOP,
    icon: const FaIcon(
    FontAwesomeIcons.print,
    color: Colors.white,
    ),
    backgroundColor: Colors.green,
    colorText: Colors.white);
    Get.offAllNamed("/mainhomepage");
    }
    },
    ),
    builder: (runMutation, result) {
      if (result!.hasException) {
        print(result.exception);
      }
      if (result!.isLoading) {
        Get
            .find<PrescriptionController>()
            .isOrderRecom
            .value = true;
      }
      return

        Obx(() =>  ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () async {
              runMutation({
                "city": Get
                    .find<Locationcontrollers>()
                    .city
                    .value,
                "defee": data["defee"],
                "totcost": data["totcost"],
                "distance": data["distance"],
                "location": Get
                    .find<Locationcontrollers>()
                    .address
                    .value,
                "lat": Get
                    .find<Locationcontrollers>()
                    .current_lat
                    .value,
                "lon": Get
                    .find<Locationcontrollers>()
                    .current_long
                    .value,
                "uid": Get
                    .find<SplashController>()
                    .prefs
                    .getInt("id"),
                "pid": data["pid"],
                "dprecid": data["dprecid"]
              });
              // showDialog(
              //   context: context,
              //   builder: (context) =>
              //       AlertDialog(
              //         title: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const Expanded(
              //               child: Text(
              //                 "Do you want to Order?",
              //                 style: TextStyle(fontSize: 18),
              //               ),
              //             ),
              //             IconButton(onPressed: () => Get.back(),
              //                 icon: const FaIcon(
              //                   FontAwesomeIcons.multiply, color: Colors.red,))
              //           ],
              //         ),
              //
              //         content: SizedBox(
              //           height: 200,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             children: [
              //               Text(
              //                 "Order your medicine to ${data["name"]}",
              //                 textAlign: TextAlign.center,
              //               ),
              //               const SizedBox(
              //                 height: 50,
              //               ),
              //               Mutation(
              //                   options: MutationOptions(
              //                     document: gql(Mymutation.orderRecomendation),
              //                     onError: (error) {
              //                       Get
              //                           .find<PrescriptionController>()
              //                           .isOrderRecom
              //                           .value = false;
              //                     },
              //                     onCompleted: (data) {
              //                       if (data!.isNotEmpty) {
              //                         Get
              //                             .find<PrescriptionController>()
              //                             .isOrderRecom
              //                             .value = false;
              //                         Get.snackbar("Success",
              //                             "you successfully order your prescription",
              //                             snackPosition: SnackPosition.TOP,
              //                             icon: const FaIcon(
              //                               FontAwesomeIcons.print,
              //                               color: Colors.white,
              //                             ),
              //                             backgroundColor: Colors.green,
              //                             colorText: Colors.white);
              //                         Get.offAllNamed("/mainhomepage");
              //                       }
              //                     },
              //                   ),
              //                   builder: (runMutation, result) {
              //                     if (result!.hasException) {
              //                       print(result.exception);
              //                     }
              //                     if (result!.isLoading) {
              //                       Get
              //                           .find<PrescriptionController>()
              //                           .isOrderRecom
              //                           .value = true;
              //                     }
              //                     return SizedBox(
              //                       width: Get.width,
              //                       child: ElevatedButton(
              //                           style: ElevatedButton.styleFrom(
              //                               padding: const EdgeInsets.all(5)
              //                           ),
              //                           onPressed: () {
              //                             runMutation({
              //                               "city": Get
              //                                   .find<Locationcontrollers>()
              //                                   .city
              //                                   .value,
              //                               "defee": data["defee"],
              //                               "totcost": data["totcost"],
              //                               "distance": data["distance"],
              //                               "location": Get
              //                                   .find<Locationcontrollers>()
              //                                   .address
              //                                   .value,
              //                               "lat": Get
              //                                   .find<Locationcontrollers>()
              //                                   .current_lat
              //                                   .value,
              //                               "lon": Get
              //                                   .find<Locationcontrollers>()
              //                                   .current_long
              //                                   .value,
              //                               "uid": Get
              //                                   .find<SplashController>()
              //                                   .prefs
              //                                   .getInt("id"),
              //                               "pid": data["pid"],
              //                               "dprecid": data["dprecid"]
              //                             });
              //                           },
              //                           child: const Text(
              //                             "Yes Order",
              //                             style: TextStyle(
              //
              //                                 color: Colors.white),
              //                           )),
              //                     );
              //                   }),
              //
              //             ],
              //           ),
              //         ),
              //       ),
              //   barrierDismissible: false,
              // );
            },
            child:Get.find<PrescriptionController>().isOrderRecom.value==true?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:const[
                ButtonSpinner(),
                SizedBox(width: 10,),
                Text("Ordering... ",style: TextStyle(color: Colors.white),)
              ],
            ):  const Text(
              "Order",
              style: TextStyle(color: Colors.white),
            )));
    }
    );
  }
}
