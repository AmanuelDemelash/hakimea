import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/screens/user/user/prescription/widget/orderprescription.dart';
import 'package:hakimea/widgets/buttonspinner.dart';
import '../../../../apiservice/myquery.dart';
import '../../../../controllers/locationcontrollers.dart';
import '../../../../controllers/user_controllers/prescriptioncontroller.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/cool_loading.dart';

class Recommendation extends StatelessWidget {
  Recommendation({Key? key}) : super(key: key);

  Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.whitesmoke,
        title: const Text(
          "My medicines ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
            )),
      ),
      body: Query(
        options:
            QueryOptions(document: gql(Myquery.recommendation), variables: {
          "medicine_name": Get.find<PrescriptionController>().medicines.value,
          "latitude": Get.find<Locationcontrollers>().current_lat.value,
          "longitude": Get.find<Locationcontrollers>().current_long.value,
        }),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [cool_loding(), Text("searching your medicine")],
            );
          }

          List medcins = result.data!["recommendation"];
          if (medcins.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FaIcon(FontAwesomeIcons.martiniGlassEmpty),
                Text("Sorry there is no any phramcy who has your medicine "),
                Text(
                    "Please Try to contact us we will find and deliver to you ")
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //top title
              Container(
                padding: const EdgeInsets.all(15),
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(
                      height: 15,
                    ),
                    Text("Recommended result"),
                    Text(
                      "pharmacy near your location and have your medicines",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              // medicin with pharmacy
              Expanded(
                child: ListView.builder(
                  itemCount: medcins.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: Get.width,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //pharma
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(medcins[index]["logo_url"]),
                            ),
                            title: Text(medcins[index]["name"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("location of the pharaamcy"),
                                RatingBar.builder(
                                  initialRating: double.parse(
                                      medcins[index]["rate"].toString()),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 9,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 1.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Constants.secondcolor,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.locationDot,
                                      size: 17,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text("${medcins[index]["distance"]} KM"),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Found medicines",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Expanded(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: medcins[index]["medicines"].length,
                                itemBuilder: (context, indexof) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(medcins[index]["medicines"][indexof]
                                        ["name"]),
                                    Text(
                                      "ETB ${medcins[index]["medicines"][indexof]["price"]}",
                                      style: const TextStyle(
                                          color: Constants.primcolor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                const Text(
                                  "Price",
                                  style: TextStyle(),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total medicin"),
                                    Text(
                                      "ETB ${medcins[index]["medicine_total"]}",
                                      style: const TextStyle(
                                          color: Constants.primcolor),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Delivery fee"),
                                    Text(
                                      "ETB ${medcins[index]["total_price"] - medcins[index]["medicine_total"]}",
                                      style: const TextStyle(
                                          color: Constants.primcolor),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Total price",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "ETB ${medcins[index]["total_price"]}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Constants.primcolor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(10),
                            child: data["num"] ==
                                    medcins[index]["medicines"].length
                                ?OrderPrescriptin(
                              data:{
                                "defee": medcins[
                                index][
                                "total_price"] -
                                    medcins[index][
                                    "medicine_total"],
                                "totcost": medcins[
                                index]
                                ["total_price"],
                                "distance": medcins[
                                index]
                                ["distance"],
                                "pid":
                                medcins[index]
                                ["id"],
                                "dprecid":
                                data["id"]
                              },
                            )

                                : const Text(""),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

