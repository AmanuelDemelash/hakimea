
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../controllers/locationcontrollers.dart';
import '../../../../utils/constants.dart';

class MedicinDetail extends StatelessWidget {
   MedicinDetail({Key? key}) : super(key: key);

  int id=Get.arguments;
   final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        backgroundColor: Constants.primcolor,
        title: const Text(
          "Medicines",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
      ),
      body: Stack(
        children: [
          Container(
            width: Get.width,
            height: 60,
            color: Constants.primcolor,
          ),
          SingleChildScrollView(
                    child:
                    Container(
                      decoration: const BoxDecoration(
                          color: Constants.whitesmoke,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20))),
                      child: Column(
                          children: [
                            // medicine ino
                            Container(
                              width: Get.width,
                              margin: const EdgeInsets.all(15),
                              padding:const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading:const CircleAvatar(
                                  radius: 25,
                                ),
                                title:Text("name"),
                                subtitle:   Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:const[
                                    Text("exp/date 23/2022",style: TextStyle(color: Colors.black54,fontSize: 13),),

                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                              padding:const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:const[
                                  Text("unit",style: TextStyle(color: Colors.black54,fontSize: 13),),
                                  SizedBox(height: 5,),
                                  Text("price ",style: TextStyle(color: Colors.black54,fontSize: 13),),
                                ],
                              ),
                            ),
                            // desc
                            Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                              padding:const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:const Text("description about the medicine \n description about the medicine "),
                            ),

                            // pharmacy
                            Container(
                              width: Get.width,
                              margin: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                              padding:const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child:Column(
                                children: [
                                  ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:[
                                        const  CircleAvatar(
                                          radius:25,
                                        ),
                                        const  SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:const [
                                              Text("name"),
                                              Text("location of the pharmacy",style: TextStyle(color: Colors.black54,fontSize: 13),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),

                                    trailing: IconButton(onPressed:() {
                                    }, icon:const FaIcon(FontAwesomeIcons.phone,color: Constants.primcolor,)),
                                  ),
                                  const SizedBox(height: 10,),
                                  SizedBox(
                                    height: 200,
                                    width: Get.width,
                                    child: GoogleMap(
                                      mapType: MapType.normal,
                                      myLocationEnabled: true,
                                      initialCameraPosition: CameraPosition(
                                        bearing: 1.0,
                                        tilt: 0.5,
                                        target: LatLng(
                                            Get.find<Locationcontrollers>().current_lat.value,
                                            Get.find<Locationcontrollers>().current_long.value),
                                        zoom: 17.4746,
                                      ),
                                      // markers: Get.find<NearByController>()
                                      //     .generateMarkers(near_pharmacy),
                                      zoomControlsEnabled: false,
                                      zoomGesturesEnabled: false,
                                      myLocationButtonEnabled: true,
                                      compassEnabled: false,
                                      onMapCreated: (GoogleMapController controller) {
                                        _controller.complete(controller);

                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),





                          ]
                      ),
                    )
                ),


        ],
      )


    );
  }
}
