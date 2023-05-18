
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';

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
          ListView.builder(
            itemCount:6,
            itemBuilder: (context, index) {
              return
                GestureDetector(
                  onTap: () => Get.toNamed("/prescdetail"),
                  child: Container(
                    width: Get.width,
                    height: 130,
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
                          decoration: BoxDecoration(
                              color: Constants.primcolor.withOpacity(0.1),
                              borderRadius:const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)
                              )
                          ),
                          child:
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:const [
                                Text("12",style:TextStyle(fontSize:25),),
                                Text("2023")
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              const   Text("Prescription",style: TextStyle(fontSize: 16),),
                              const SizedBox(height: 10,),
                              // doc
                              Row(
                                children:const[
                                  CircleAvatar(
                                    radius: 13,
                                  ),
                                  SizedBox(width: 10,),
                                  Text("doctor name")
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Row(
                                    children:const[
                                      Icon(Icons.medication,size: 14,),
                                      Text("3",style: TextStyle(fontSize:14),)
                                    ],
                                  ),
                                  const SizedBox(width: 15,),
                                  Row(
                                    children:const[
                                      Icon(Icons.local_pharmacy_sharp,size: 14,),
                                      Text("3",style: TextStyle(fontSize:14),),
                                      SizedBox(width: 7,),
                                      Text("pharmacy",style: TextStyle(fontSize:14,color:Colors.black54),)
                                    ],
                                  ),

                                ],
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                padding:const EdgeInsets.all(3),
                                child:Row(
                                  children: [
                                    Icon(Icons.check_circle,color: Constants.primcolor.withOpacity(0.4),),
                                    const Text("pending",style: TextStyle(color: Constants.primcolor,fontSize: 14),),
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
            },)
        ],
      ),


    );
  }
}
