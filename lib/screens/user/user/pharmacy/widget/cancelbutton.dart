
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/widgets/buttonspinner.dart';
import '../../../../../apiservice/mymutation.dart';
import '../../../../../controllers/user_controllers/ordercontroller.dart';
import '../../../../../utils/constants.dart';
import '../../../../../widgets/cool_loading.dart';

class CancelButton extends StatelessWidget {
  int order_id;
  CancelButton({Key? key,required this.order_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Mutation(
        options: MutationOptions(
          document: gql(Mymutation.delete_order),
          onCompleted: (data) async {
            if (data!.isNotEmpty) {
              Get.find<OrderController>().is_canceling_order.value =
              false;
            }
          },
          onError: (error) {
            Get.find<OrderController>().is_canceling_order.value =
            false;
          },
        ),
        builder: (runMutation, result) {
          if (result!.hasException) {
            Get.find<OrderController>().is_canceling_order.value =
            false;
          }
          if (result.isLoading) {
            Get.find<OrderController>().is_canceling_order.value =
            true;
          }

          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  side: const BorderSide(color: Constants.primcolor),
                  backgroundColor: Colors.white),
              onPressed: () async {
                // run cancel order mutation
                Get.defaultDialog(
                    titlePadding:const EdgeInsets.all(6),
                    contentPadding:const EdgeInsets.all(10),
                    barrierDismissible: false,
                    title: "",
                    content: Column(children:const[
                      Text("Are you sure?")
                    ],),
                    actions:[
                      Get.find<OrderController>().is_canceling_order.value==true?
                      const cool_loding()
                          :  AnimatedContainer(duration:const Duration(seconds: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(onPressed:() => Get.back(), child:const Text("No",style: TextStyle(color: Colors.red))),
                            TextButton(onPressed:(){
                              runMutation({"id":order_id});

                            }, child:const Text("Yes",style: TextStyle(color: Constants.primcolor),)),

                          ],
                        ),
                      )
                    ]
                );
              },
              child:Get.find<OrderController>().is_canceling_order.value==true
            ? const ButtonSpinner() :const Text(
                "Cancel Order",
                style: TextStyle(color: Constants.primcolor),
              ));
        }
    );
  }
}
