
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/cool_loading.dart';

class Prescription extends StatelessWidget {
  const Prescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body:Stack(
        children: [
          Container(
            width: Get.width,
            height: 60,
            decoration:const BoxDecoration(
                color: Constants.primcolor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                )
            ),
          ),
          Query(options: QueryOptions(document: gql(Myquery.prescriptions),
          variables: {
            "id":Get.find<SplashController>().prefs.getInt("id")
          },
            pollInterval: const Duration(seconds: 10)
          ),
            builder:(result, {fetchMore, refetch}) {
            if(result.hasException){
              return const cool_loding();
            }
            if(result.isLoading){
              return const cool_loding();
            }
            List? presc=result.data!["prescriptions"];
            if(presc!.isEmpty){
              return SizedBox(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:const[
                      FaIcon(FontAwesomeIcons.prescription,size:40),
                       SizedBox(height: 10,),
                      Text("no prescription yet!",style: TextStyle(color: Colors.black54),)
                    ],
                  ),
                ),
              );
            }
            return
              ListView.builder(
                itemCount:presc!.length,
                itemBuilder: (context, index) {
                  return
                    GestureDetector(
                      onTap: (){
                        Get.toNamed("/prescdetail",arguments:{
                          "id":presc[index]["id"],
                          "num":presc[index]["prescribed_medicines"].length
                        });
                      },

                      child: Container(
                        width: Get.width,
                        margin:const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            // date
                            Container(
                              width:100,
                              decoration:const BoxDecoration(
                                  borderRadius:BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)
                                  )
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(presc![index]["created_at"].toString().substring(5,7),style:const TextStyle(fontSize:25,color: Constants.primcolor),),
                                    Text(presc![index]["created_at"].toString().substring(0,4),style: TextStyle(color: Constants.primcolor.withOpacity(0.6)),)
                                  ],
                                ),

                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  const   Text("Prescription",style: TextStyle(fontSize: 16,color: Colors.black54),),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children:[
                                      CircleAvatar(
                                        radius: 13,
                                        backgroundImage: NetworkImage(presc[index]["doctor"]["profile_image"]["url"]),
                                      ),
                                      const SizedBox(width: 10,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(presc[index]["doctor"]["full_name"].toString()),
                                          Text(presc[index]["doctor"]["speciallities"]["speciallity_name"].toString(),style: TextStyle(color: Colors.black54),),

                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      Row(
                                        children:[
                                          const Icon(Icons.medication,size:20,),
                                          Text(presc[index]["prescribed_medicines"].length.toString(),style:const TextStyle(fontSize:14),)
                                        ],
                                      ),
                                      const SizedBox(width: 15,),
                                      const Text("Medicines")
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    padding:const EdgeInsets.all(3),
                                    child:Row(
                                      children: [
                                        Icon(Icons.check_circle,color: presc[index]["orders"][0]["status"]=="pending"?Colors.red:Constants.primcolor.withOpacity(0.5),),
                                        Text(presc[index]["orders"][0]["status"],style:TextStyle(color:presc[index]["orders"][0]["status"]=="pending"?Colors.red:Constants.primcolor,fontSize: 14),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const FaIcon(FontAwesomeIcons.angleRight),
                            const SizedBox(width: 20,)
                          ],
                        ),
                      ),
                    );
                },);
          },)
        ],
      ),


    );
  }
}
