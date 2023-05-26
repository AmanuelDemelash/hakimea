
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/widgets/cool_loading.dart';

import '../../../../controllers/user_controllers/prescriptioncontroller.dart';
import '../../../../utils/constants.dart';

class PrescriptionDetail extends StatelessWidget {
   PrescriptionDetail({Key? key}) : super(key: key);
  Map<String,dynamic>data=Get.arguments;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primcolor,
          title: const Text(
            "My prescription",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.white,
              )),
          actions: [
            IconButton(onPressed:() {
              Get.find<PrescriptionController>().takeScreenshot();

            }, icon:const FaIcon(FontAwesomeIcons.print,color: Colors.white,))
          ],
        ),
        floatingActionButton:FloatingActionButton.extended(onPressed:()async{
          if(Get.find<PrescriptionController>().medicines.value.isNotEmpty){
            Get.toNamed("/recommend",arguments:data);
          }

        },
            icon:const FaIcon(FontAwesomeIcons.locationArrow),
            label:const Text("Find Medicne")),
        body:Stack(
          children: [
            Container(
              width: Get.width,
              height: 50,
              decoration:const BoxDecoration(
                color: Constants.primcolor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft:  Radius.circular(15)
                )
              ),
            ),
            Query(options: QueryOptions(document: gql(Myquery.prescDetail),
            variables: {
              "id":data["id"]
            }
            ),
              builder:(result, {fetchMore, refetch}){
              if(result.hasException){
                return const cool_loding();
              }
              if(result.isLoading){
                return const cool_loding();
              }
              Map<String,dynamic> presc=result.data!["prescriptions_by_pk"];
              Get.find<PrescriptionController>().getmedicines(presc["prescribed_medicines"]);
              return RepaintBoundary(
                key: Get.find<PrescriptionController>().key,
                child: SingleChildScrollView(
                  physics:const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width,
                        margin:const EdgeInsets.all(10),
                        padding:const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //logo
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Image.asset("assets/images/logo.png",width: 60,height: 60,),
                                    const Text("Hakime"),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 15,),
                            const Text("Patient information",style: TextStyle(color: Colors.black54),),
                            const SizedBox(height: 10,),
                            Text("Name :  ${presc["patient"]["full_name"]}"),
                            Text("Age :  ${presc["patient"]["age"]}"),
                            Text("Phone :  ${presc["user"]["phone_number"]}"),
                            const SizedBox(height: 20),
                            const Text("Doctor  information",style: TextStyle(color: Colors.black54),),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(presc["doctor"]["profile_image"]["url"]),
                              ),
                              title: Text(presc["doctor"]["full_name"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(presc["doctor"]["speciallities"]["speciallity_name"]),
                                  Text(presc["doctor"]["sex"]),
                                  Text(presc["doctor"]["phone_number"])
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            const Text("Date:"),
                            Text(presc["created_at"].toString().substring(0,10),style:const TextStyle(color: Colors.black54),),
                            const SizedBox(height: 10,),
                            const Text("Status:"),
                            Text(presc["orders"][0]["status"],style:TextStyle(fontWeight: FontWeight.bold,color:presc["orders"][0]["status"]=="pending"?Colors.red:Constants.primcolor,fontSize:18),),
                          ],
                        ),
                      ),
                      //medicine
                      Container(
                        width: Get.width,
                        margin:const EdgeInsets.all(10),
                        //padding:const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            const Text("Medicines"),
                            ListView.builder(
                              physics:const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:presc["prescribed_medicines"].length,
                              itemBuilder:(context, index) {
                                return  ListTile(
                                  title: Text(presc["prescribed_medicines"][index]["medicine_name"]),
                                  subtitle: Text(presc["prescribed_medicines"][index]["dose"]),
                                  trailing:const Icon(Icons.check_circle),
                                );
                              },)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },)

          ],
        )
    
      );
  }
}
