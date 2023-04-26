import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/controllers/user_controllers/ordercontroller.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import '../../../../../utils/constants.dart';

class NewOrderCard extends StatelessWidget {
  // int id;
  // String pharm_name;
  // String location;
  // String order_code;
  // String logo;
  // int index;
  // String user_addres;

  Map<String, dynamic> order_data;

  NewOrderCard({
    Key? key,
    required this.order_data,
    // required this.index,
    // required this.id,
    // required this.pharm_name,
    // required this.location,
    // required this.order_code,
    // required this.user_addres,
    // required this.logo
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pharmacy",
                  style: TextStyle(color: Colors.black54),
                ),
                Row(
                  children: [
                    const Text("Code: "),
                    Text(
                      order_data["order_code"],
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //pharmacy
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order_data["location"],
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
              child: CachedNetworkImage(
                imageUrl: order_data["logo"],
                width: 60,
                height: 60,
                placeholder: (context, url) => const Icon(Icons.image),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(order_data["pharm_name"]),
          ),
          const SizedBox(
            height: 3,
          ),
          // user location
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "My location",
              style: TextStyle(color: Colors.black54),
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.only(left: 40),
            leading: const FaIcon(FontAwesomeIcons.user),
            title: Flexible(
                child: Text(
              order_data["user_addres"].toString(),
              style: const TextStyle(color: Colors.black54),
            )),
            subtitle: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text("Date: "),
                        Text(
                          order_data["order_date"].toString().substring(0, 9),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 15,
          ),
          // canccel order
          Container(
              width: Get.width,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Mutation(
                  options: MutationOptions(
                    document: gql(Mymutation.delete_order),
                    onCompleted: (data) async {
                      if (data!.isNotEmpty) {
                        Get.find<OrderController>().is_canceling_order.value =
                            false;
                      }
                    },
                    onError: (error) {
                      Get.find<OrderController>().is_canceling_order.value =
                          false;
                    },
                  ),
                  builder: (runMutation, result) {
                    if (result!.hasException) {
                      Get.find<OrderController>().is_canceling_order.value =
                          false;
                    }
                    if (result.isLoading) {
                      Get.find<OrderController>().is_canceling_order.value =
                          true;
                    }

                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            side: const BorderSide(color: Constants.primcolor),
                            backgroundColor: Colors.white),
                        onPressed: () async {
                          // run cancel order mutation
                          runMutation({"id": order_data["id"]});
                        },
                        child: Get.find<OrderController>()
                                    .is_canceling_order
                                    .value ==
                                true
                            ? const cool_loding()
                            : const Text(
                                "Cancel Order",
                                style: TextStyle(color: Constants.primcolor),
                              ));
                  }))
        ],
      ),
    );
  }
}
