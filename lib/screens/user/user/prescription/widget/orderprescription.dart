import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/widgets/buttonspinner.dart';

import '../../../../../apiservice/mymutation.dart';
import '../../../../../controllers/locationcontrollers.dart';
import '../../../../../controllers/splashcontroller.dart';
import '../../../../../controllers/user_controllers/prescriptioncontroller.dart';

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
            print(error!.graphqlErrors.first.message.toString());
          },
          onCompleted: (data) {
            if (data!.isNotEmpty) {
              Get.find<PrescriptionController>().isOrderRecom.value = false;
              Get.snackbar(
                  "Success", "you successfully order your prescription",
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
            print(result.exception.toString());
          }
          if (result!.isLoading) {
            Get.find<PrescriptionController>().isOrderRecom.value = true;
          }
          return Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
              ),
              onPressed: () async {
                runMutation({
                  "city": Get.find<Locationcontrollers>().city.value,
                  "defee": data["defee"],
                  "totcost": data["totcost"],
                  "distance": data["distance"],
                  "location": Get.find<Locationcontrollers>().address.value,
                  "lat": Get.find<Locationcontrollers>().current_lat.value,
                  "lon": Get.find<Locationcontrollers>().current_long.value,
                  "uid": Get.find<SplashController>().prefs.getInt("id"),
                  "pid": data["pid"],
                  "dprecid": data["dprecid"]
                });
              },
              child:
                  Get.find<PrescriptionController>().isOrderRecom.value == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            ButtonSpinner(),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Ordering... ",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        )
                      : const Text(
                          "Order",
                          style: TextStyle(color: Colors.white),
                        )));
        });
  }
}
