import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants.dart';

class UpcomingOrderCard extends StatelessWidget {
  int id;
  String phname;
  String location;
  String image;
  String code;
  String date;
  String status;
  UpcomingOrderCard(
      {Key? key,
      required this.id,
      required this.code,
      required this.image,
      required this.location,
      required this.date,
      required this.status,
      required this.phname})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed("/orderdetailstatus",arguments: id);
          },
          child: Container(
          height: 110,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding:const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width:50,
                  height:50,
                  placeholder: (context, url) => const Icon(Icons.image),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 6,),
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Flexible(child: Text(phname)),
                  Flexible(
                    child: Text(
                      location,
                      style: const TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Date: ${date.substring(0, 10)}",
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Order Code: ",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      Text(
                        code,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  )
                ],
              )
              )
            ],
          )
    ),
        ),

    Positioned(
      top: 5,
      right: 0,
      child:  Container(
        padding:const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Constants.primcolor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(5)
      ),
      child:Text(status,style:const TextStyle(color: Colors.white),),

    ),)
      ],
    );

  }
}
