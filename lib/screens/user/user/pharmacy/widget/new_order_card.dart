import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants.dart';
import 'cancelbutton.dart';

class NewOrderCard extends StatelessWidget {
  Map<String, dynamic> order_data;

  NewOrderCard({
    Key? key,
    required this.order_data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
    AnimatedContainer(
    duration: const Duration(seconds: 5),
    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
    padding:const EdgeInsets.all(10),
    decoration: BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.circular(10)),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(
    height: 5,
    ),
    const SizedBox(
    height: 5,
    ),
    //pharmacy
    Row(
    children: [
    ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
    imageUrl: order_data["logo"],
    width: 50,
    height: 50,
    placeholder: (context, url) => const Icon(Icons.image),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    fit: BoxFit.cover,
    ),
    ),
    const SizedBox(
    width: 10,
    ),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(order_data["pharm_name"]),
    Text(
    order_data["location"],
    style: const TextStyle(
    color: Colors.black54,
    ),
    ),
    ],
    ))
    ],
    ),
    const SizedBox(height: 8,),
    // date and code
    Text(
    "date:  ${order_data["order_date"].toString().substring(0, 9)}",
    style: const TextStyle(color: Colors.black54),
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
    const SizedBox(
    height: 3,
    ),
    const SizedBox(
    height: 15,
    ),
    // canccel order
    Container(
    width: Get.width,
    margin: const EdgeInsets.only(left: 10, right: 10),
    child:CancelButton(order_id:order_data["id"] ,)
    )
    ],
    ),
    ),
        Positioned(
          top: 5,
          right: 0,
          child:  Container(
            padding:const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Constants.secondcolor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5)
            ),
            child:Text(order_data["status"],style:const TextStyle(color: Colors.white),),

          ),)

      ],
    );


  }
}
