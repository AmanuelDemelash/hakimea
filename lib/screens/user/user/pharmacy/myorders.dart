import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/screens/user/user/pharmacy/widget/new_order_card.dart';
import 'package:hakimea/screens/user/user/pharmacy/widget/upcoming_order_card.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import 'package:hakimea/widgets/no_appointment_found.dart';

import '../../../../controllers/splashcontroller.dart';
import '../../../../widgets/loginalert.dart';

class Myorder extends StatelessWidget {
  const Myorder({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.primcolor,
          automaticallyImplyLeading: false,
          title: const Text(
            "My Orders",
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
          bottom: const TabBar(
              indicatorColor: Constants.whitesmoke,
              unselectedLabelColor: Colors.white54,
              labelColor: Colors.white,
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              tabs: [
                Tab(
                  child: Text("New"),
                ),
                Tab(
                  child: Text("Upcoming"),
                ),
                Tab(
                  child: Text("complated"),
                )
              ]),
        ),
        body: Get.find<SplashController>().prefs.getString("token") == null
            ? const loginalert()
            : TabBarView(children: [
                // new orders
                Query(
                  options: QueryOptions(
                      document: gql(Myquery.newOrder),
                      variables: {
                        "user_id":
                            Get.find<SplashController>().prefs.getInt("id")
                      },
                      pollInterval: const Duration(seconds:3)),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      print(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return const cool_loding();
                    }

                    // get orders
                    List? orders = result.data!["orders"];
                    if (orders!.isEmpty) {
                      return no_appointment_found(title: "No new order!");
                    }
                    return AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: Get.height,
                        width: Get.width,
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                      child: GestureDetector(
                                    onTap: () =>
                                        Get.toNamed("/orderdetail", arguments: {
                                      "id": orders[index]["id"],
                                      "order_code": orders[index]["order_code"],
                                      "total_cost": orders[index]["total_cost"],
                                      "delivery_cost": orders[index]
                                          ["delivery_fee"],

                                    }),
                                    child: NewOrderCard(
                                      order_data: {
                                        "id": orders[index]["id"],
                                        "user_addres": orders[index]
                                            ["order_address"]["location"],
                                        "location": orders[index]["pharmacy"]
                                            ["address"]["location"],
                                        "order_code": orders[index]
                                            ["order_code"],
                                        "pharm_name": orders[index]["pharmacy"]
                                            ["name"],
                                        "logo": orders[index]["pharmacy"]
                                            ["logo_image"]["url"],
                                        "order_date": orders[index]
                                            ["created_at"],
                                        "status":orders[index]["status"]
                                      },
                                    ),
                                  )),
                                ),
                              ),
                            );
                          },
                        ));
                  },
                ),
                // upcomming
                Query(
                  options: QueryOptions(
                      document: gql(Myquery.upcomming_orders),
                      variables: {
                        "id": Get.find<SplashController>().prefs.getInt("id")
                      }),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      print(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return const cool_loding();
                    }
                    List? upcomingorder = result.data!["orders"];
                    if (upcomingorder!.isEmpty) {
                      return no_appointment_found(
                          title: "No upcoming order found!");
                    }
                    return SingleChildScrollView(
                      child:
                      AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          height: Get.height,
                          width: Get.width,
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: upcomingorder.length,
                            itemBuilder: (context, index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                      child: GestureDetector(
                                    child: UpcomingOrderCard(
                                      id: upcomingorder[index]["id"],
                                      code: upcomingorder[index]["order_code"],
                                      image: upcomingorder[index]["pharmacy"]
                                          ["logo_image"]["url"],
                                      location: upcomingorder[index]["pharmacy"]
                                          ["address"]["location"],
                                      phname: upcomingorder[index]["pharmacy"]
                                          ["name"],
                                      date: upcomingorder[index]["created_at"],
                                      status: upcomingorder[index]["status"],
                                    ),
                                  )),
                                ),
                              );
                            },
                          )),
                    );
                  },
                ),
                // completed
                Query(
                  options: QueryOptions(
                      document: gql(Myquery.completed_order),
                      variables: {
                        "user_id":
                            Get.find<SplashController>().prefs.getInt("id")
                      }),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.isLoading) {
                      return const cool_loding();
                    }
                    // get completed order
                    List? orders = result.data!["orders"];
                    if (orders!.isEmpty) {
                      return no_appointment_found(
                          title: "No any completed order found!");
                    }
                    return Container();
                  },
                )
              ]),
      ),
    );
  }
}
