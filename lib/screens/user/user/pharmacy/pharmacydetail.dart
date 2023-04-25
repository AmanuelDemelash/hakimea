import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hakimea/controllers/locationcontrollers.dart';
import 'package:hakimea/controllers/user_controllers/pharmacycontroller.dart';
import '../../../../utils/constants.dart';

class PharmacyDetail extends StatelessWidget {
  PharmacyDetail({Key? key}) : super(key: key);

  Completer<GoogleMapController> _controller = Completer();
  MedicinDatatableSource medsource = MedicinDatatableSource();

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
                  color: Colors.black,
                )),
            elevation: 0,
            pinned: false,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
                background: GetBuilder<Locationcontrollers>(
              initState: (state) => Get.find<Locationcontrollers>(),
              builder: (controller) {
                return AnimationConfiguration.staggeredList(
                  position: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: GoogleMap(
                        mapType: MapType.terrain,
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                Get.find<Locationcontrollers>()
                                    .locationData
                                    .latitude!,
                                Get.find<Locationcontrollers>()
                                    .locationData
                                    .longitude!),
                            zoom: 12.5),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: {
                          Marker(
                              markerId: MarkerId("myloc"),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueGreen),
                              position: LatLng(
                                  controller.locationData.latitude!,
                                  controller.locationData.longitude!))
                        },
                      ),
                    ),
                  ),
                );
              },
            )),
          ),
          SliverFillRemaining(
              hasScrollBody: true,
              fillOverscroll: true,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                        imageUrl:
                                            "https://images.unsplash.com/photo-1622230208995-0f26eba75875?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
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
                                        const Text(
                                          "Pharmacy name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text("kebele 12, Bahirdar "),
                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              initialRating: 3,
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
                                              width: 10,
                                            ),
                                            const Text("(4.5)"),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                                radius: 16,
                                                backgroundImage: NetworkImage(
                                                    "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80")),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text("Amanuel demelash"),
                                                Text(
                                                  "0947054595",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Container(
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
                      child: PaginatedDataTable(
                          header: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Medicine stock",
                                style: TextStyle(),
                              ),
                              Text(
                                "210 medicines",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                          rowsPerPage: 5,
                          headingRowHeight: 40,
                          columns: const [
                            DataColumn(label: Text("Image")),
                            DataColumn(label: Text("name")),
                            DataColumn(label: Text("price"))
                          ],
                          source: medsource),
                    ),
                  ]))
        ]));
  }
}

class MedicinDatatableSource extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: Get.find<PharmacyController>().medicin[index]["image"],
            width: 50,
            height: 50,
            placeholder: (context, url) => const Icon(Icons.image),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
      )),
      DataCell(Text(Get.find<PharmacyController>().medicin[index]["name"])),
      DataCell(Text(
          "ETB ${Get.find<PharmacyController>().medicin[index]["price"].toString()}")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Get.find<PharmacyController>().medicin.length;

  @override
  int get selectedRowCount => 0;
}
