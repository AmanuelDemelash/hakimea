
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/ordercontroller.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import '../../../../controllers/locationcontrollers.dart';
import '../../../../controllers/user_controllers/pharmacycontroller.dart';
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
          "Medicine",
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
                      child:
                      Query(options: QueryOptions(document:gql(Myquery.medicin_detail),
                       variables:{
                        "id":id
                       }
                      ),
                      builder: (result, {fetchMore, refetch}) {
                        if(result.hasException)
                          {
                            return SizedBox(
                                width:Get.width,
                                height: Get.height,
                                child:const cool_loding());
                          }
                        if(result.isLoading){
                          return SizedBox(
                              width:Get.width,
                              height: Get.height,
                              child:const cool_loding());
                        }

                        Map<String,dynamic> medicine=result.data!["medicine_by_pk"];
                        return Column(
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
                                  leading:CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(medicine["medicine_image"]["url"]),
                                  ),
                                  title:Text(medicine["name"]),
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
                                  children:[
                                   const Text("unit: ",style: TextStyle(color: Colors.black54,fontSize: 13),),
                                   const SizedBox(height: 5,),
                                    Text("price: ETB ${medicine["price"].toString()}",style:const TextStyle(color: Colors.black),),
                                    const SizedBox(height: 15,),
                                    const Text("Description"),
                                    const SizedBox(height: 10,),
                                    Text(medicine["description"]),
                                  ],
                                ),
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
                                      leading:CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(medicine["medicine_pharmacy"]["logo_image"]["url"]),
                                      ),
                                      title: Text(medicine["medicine_pharmacy"]["name"]),
                                      subtitle:Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          Text(medicine["medicine_pharmacy"]["address"]["location"],
                                            style:const TextStyle(color: Colors.black54,fontSize: 13),),
                                            const SizedBox(height: 6,),
                                            Row(
                                              children:[
                                               const  FaIcon(FontAwesomeIcons.clock,color: Constants.primcolor,size: 13,),
                                                const SizedBox(width:10),
                                                Text(medicine["medicine_pharmacy"]["open_time"]),
                                               const Text(" - "),
                                                Text(medicine["medicine_pharmacy"]["close_time"]),
                                              ],
                                            ),
                                        ],
                                      ),

                                      trailing: IconButton(onPressed:() {
                                      }, icon:const FaIcon(FontAwesomeIcons.phone,color: Constants.primcolor,)),
                                    ),
                                    const SizedBox(height: 10,),
                                    Stack(
                                      children: [
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
                                                  medicine["medicine_pharmacy"]["address"]["latitude"],
                                                  medicine["medicine_pharmacy"]["address"]["longitude"]),
                                              zoom: 17.4746,
                                            ),

                                            markers:{
                                              Marker(markerId:const MarkerId("phrmacy"),
                                                  icon: Get.find<OrderController>().pharm_marker,
                                                  position: LatLng( medicine["medicine_pharmacy"]["address"]["latitude"],
                                                      medicine["medicine_pharmacy"]["address"]["longitude"])
                                              )
                                            },
                                            zoomControlsEnabled: false,
                                            zoomGesturesEnabled: false,
                                            myLocationButtonEnabled: true,
                                            compassEnabled: false,
                                            onMapCreated: (GoogleMapController controller) {
                                              _controller.complete(controller);

                                            },
                                          ),
                                        ),
                                        // calculate
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Container(
                                            
                                            height: 30,
                                            padding:const EdgeInsets.all(3),
                                            decoration:const BoxDecoration(
                                                color: Constants.primcolor,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10)
                                              )
                                            ),
                                            child: Center(child: Text("${Get.find<PharmacyController>().calculateDistance(medicine["medicine_pharmacy"]["address"]["latitude"], medicine["medicine_pharmacy"]["address"]["longitude"],
                                                Get.find<Locationcontrollers>().current_lat.value, Get.find<Locationcontrollers>().current_long.value)} Km from your location",
                                              style:const TextStyle(color: Constants.whitesmoke),
                                            )
                                            ),
                                          ),
                                        )


                                      ],
                                    )

                                  ],
                                ),
                              ),

                            ]
                        );
                      },
                      )


                    )
                ),


        ],
      )


    );
  }
}
