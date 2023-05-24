
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../apiservice/myquery.dart';
import '../../../../controllers/locationcontrollers.dart';
import '../../../../controllers/user_controllers/prescriptioncontroller.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/cool_loading.dart';

class Recommendation extends StatelessWidget {
  const Recommendation({Key? key}) : super(key: key);

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
            )
        ),
      ),
      body:
      Query(options: QueryOptions(document:gql(Myquery.recommendation),
          variables:{
            "medicine_name":Get.find<PrescriptionController>().medicines.value,
            "latitude":Get.find<Locationcontrollers>().current_lat.value,
            "longitude":Get.find<Locationcontrollers>().current_long.value,
          }
      ),
        builder:(result, {fetchMore, refetch}){
          if(result.isLoading){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:const[
                cool_loding(),
                Text("searching your medicine")
              ],
            );
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                //top title
                Container(
                  padding: const EdgeInsets.all(15),
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:const[
                       SizedBox(height: 15,),
                       Text("Recommended result"),
                       Text("pharmacy near your location and have your medicines",style: TextStyle(color: Colors.black54),),
                    ],
                  ),
                ),
                // medicin with pharmacy
                Expanded(
                  child: ListView.builder(
                    itemCount: 2,
                    itemBuilder:(context, index) {
                      return Container(
                        width: Get.width,
                        margin:const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //pharma
                            ListTile(
                              leading:CircleAvatar(
                                radius:21,
                              ),
                              title: Text("phrma name"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("location of the pharaamcy"),
                                  RatingBar.builder(
                                    initialRating:3.0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 9,
                                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Constants.secondcolor,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.locationDot,size: 17,),
                                      const SizedBox(width: 10,),
                                      Text("12 KM"),

                                    ],
                                  )


                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text("Found medicines",style: TextStyle(color:Colors.black54),),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children:List.generate(2, (index) =>
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                  children:[
                                      Text("med 1"),
                                      Text("ETB 100",style: TextStyle(color: Constants.primcolor),)
                                  ],
                                ),
                                    ) ,
                                )),
                            ),

                            const SizedBox(height: 15,),
                            Container(
                              width: Get.width,
                              padding:const EdgeInsets.all(10),
                              child: Column(

                                children: [
                                  const Text("Price",style: TextStyle(),),
                                  const SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total medicin"),
                                      Text("ETB 100",style: TextStyle(color: Constants.primcolor),)

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Delivery fee"),
                                      Text("ETB 50",style: TextStyle(color: Constants.primcolor),)

                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Divider(height: 1,thickness: 1,color: Colors.grey.withOpacity(0.5),),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:[
                                      Text("Total price",style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text("ETB 250",style: TextStyle(color: Constants.primcolor,fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height:20,)



                          ],
                        ),
                      );


                  },),
                )
              ],

          );

        },),
    );
  }
}
