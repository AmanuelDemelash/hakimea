import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/locationcontrollers.dart';
import 'package:hakimea/controllers/user_controllers/ordercontroller.dart';
import 'package:hakimea/controllers/user_controllers/pharmacycontroller.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import 'package:hakimea/widgets/no_appointment_found.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/constants.dart';

class PharmacyDetail extends StatelessWidget {
  PharmacyDetail({Key? key}) : super(key: key);

  Completer<GoogleMapController> _controller = Completer();
  MedicinDatatableSource medsource = MedicinDatatableSource();
  Map<String,dynamic> pharma=Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Constants.whitesmoke,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const FaIcon(
                  FontAwesomeIcons.angleLeft,
                  color: Constants.primcolor,
                )),
            elevation: 0,
            pinned: false,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
                background: AnimationConfiguration.staggeredList(
                  position: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.terrain,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    pharma["address"]["latitude"],
                                    pharma["address"]["longitude"]
                                ),
                                zoom: 17.5),

                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            markers: {
                              Marker(
                                  markerId:const MarkerId("pharma"),
                                  icon: Get.find<OrderController>().pharm_marker,
                                  position: LatLng(
                                      pharma["address"]["latitude"],
                                      pharma["address"]["longitude"]))
                            },
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration:const BoxDecoration(
                                color: Constants.primcolor
                              ),
                              child: Center(child: Text("${Get.find<PharmacyController>().calculateDistance(pharma["address"]["latitude"], pharma["address"]["longitude"],
                                  Get.find<Locationcontrollers>().current_lat.value, Get.find<Locationcontrollers>().current_long.value)} Km apart",
                                style:const TextStyle(color: Constants.whitesmoke),
                              )
                              ),
                            ),
                          )
                        ],
                      )

    ) )))),

          SliverFillRemaining(
              hasScrollBody: true,
              fillOverscroll: true,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    //pharmacy
                    AnimationConfiguration.staggeredList(
                      position: 1,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: Container(
                            width: Get.width,
                            height: 130,
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl:pharma["logo_image"]["url"]
                                            ,
                                        width: 100,
                                        height: 130,
                                        placeholder: (context, url) =>
                                            const Icon(Icons.image),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          pharma["name"],
                                          style:const  TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                         Text(pharma["address"]["location"]),

                                            RatingBar.builder(
                                              initialRating:double.parse(pharma["rate"].toString()),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Constants.primcolor,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),

                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                                radius: 16,
                                                backgroundImage: NetworkImage(
                                                    pharma["owner_information"]["image"]["url"])),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:[
                                                Text(pharma ["owner_information"]["full_name"]),
                                                Text(
                                                  pharma["phone_number"],
                                                  style:const TextStyle(
                                                      color: Colors.black54),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              width:50,
                                            ),
                                            GestureDetector(
                                              onTap: () => launch("tel:${pharma["phone_number"]}"),
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                decoration: const BoxDecoration(
                                                    color: Constants.primcolor,
                                                    shape: BoxShape.circle),
                                                child: const Center(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.phone,
                                                    color: Constants.whitesmoke,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // medicines
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child:
                    Query(options: QueryOptions(document: gql(Myquery.pharma_medicins),
                    variables: {
                      "id":pharma["id"]
                    }
                    ),
                   builder: (result, {fetchMore, refetch}) {
                     if(result.hasException){
                       return Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children:[
                           const cool_loding(),
                           const SizedBox(height: 15,),
                           Text("medicines found in ${pharma["name"]} ..")
                         ],
                       );
                     }

                      if(result.isLoading){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                           const cool_loding(),
                            const SizedBox(height: 15,),
                            Text("medcines found in ${pharma["name"]} ..")
                          ],
                        );
                      }

                    List medicines=result.data!["medicine"];
                    if(medicines!.isEmpty){
                    return  Column(children: [
                        no_appointment_found(title: "no medicine found in ${pharma["name"]} ")
                      ],);
                    }else{
                      Get.find<PharmacyController>().medicin.value=medicines;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: PaginatedDataTable(
                            header: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                               const Text(
                                  "Medicine stock",
                                  style: TextStyle(),
                                ),
                                Text(
                                  "${medicines.length} medicines",
                                  style:const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            rowsPerPage: 5,
                            headingRowHeight: 40,
                            columnSpacing:70.0,
                            columns: const [
                              DataColumn(label: Text("Image")),
                              DataColumn(label: Text("name")),
                              DataColumn(label: Text("price"))
                            ],
                            source: medsource),
                    );

                    },)

                    ),
                  ]))
        ]));
  }
}

class MedicinDatatableSource extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow(
        cells: [
      DataCell(Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: Get.find<PharmacyController>().medicin.value[index]["medicine_image"]["url"],
            width: 50,
            height: 50,
            placeholder: (context, url) => const Icon(Icons.image),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      )),
      DataCell(Text(Get.find<PharmacyController>().medicin.value[index]["name"])),
      DataCell(Text(
          "ETB ${Get.find<PharmacyController>().medicin.value[index]["price"].toString()}")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Get.find<PharmacyController>().medicin.value.length;

  @override
  int get selectedRowCount => 0;
}
