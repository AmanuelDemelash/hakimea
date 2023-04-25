import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/pharmacycontroller.dart';
import 'package:hakimea/screens/user/user/pharmacy/widget/pharmacy_card.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/no_appointment_found.dart';
import '../../../../controllers/user_controllers/signupcontroller.dart';
import 'widget/pharmacy_shmmer.dart';

class Pharmacy extends StatelessWidget {
  Pharmacy({Key? key}) : super(key: key);

  TextEditingController _searchtext = TextEditingController();
  int _limit = 5;
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        backgroundColor: Constants.primcolor,
        title: const Text(
          "Pharmacy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.find<PharmacyController>().pharmacy_search_key.value == "";
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          Container(
              width: Get.width,
              height: 100,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Constants.primcolor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: TextFormField(
                controller: _searchtext,
                keyboardType: TextInputType.text,
                enabled: true,
                autofocus: false,
                onChanged: (newValue) {
                  Get.find<PharmacyController>()
                      .change_search_key(newValue.toString());
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  } else if (value.contains(RegExp(r'[1-9]'))) {
                    return Get.find<SignUpController>()
                        .customsnack("enter valid search key");
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "search pharmacy",
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 17,
                      color: Constants.primcolor,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.microphone,
                          color: Constants.primcolor,
                        )),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.whitesmoke),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.whitesmoke),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.whitesmoke),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.whitesmoke),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    fillColor: Colors.white),
              )),
          const SizedBox(
            height: 15,
          ),
          Obx(
            () => Query(
              options:
                  Get.find<PharmacyController>().pharmacy_search_key.value == ""
                      ? QueryOptions(
                          document: gql(Myquery.all_pharmacy),
                          variables: {
                            'limit': _limit,
                            'offset': _offset,
                          },
                        )
                      : QueryOptions(
                          document: gql(Myquery.search_pharmacy),
                          variables: {
                              "name":
                                  "%${Get.find<PharmacyController>().pharmacy_search_key.value}%"
                            }),
              builder: (result, {fetchMore, refetch}) {
                if (result.hasException) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) => pharmacy_shimmer(),
                    ),
                  );
                }
                if (result.isLoading) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) => pharmacy_shimmer(),
                    ),
                  );
                }
                // get all pharmacy
                List? pharmacy = result.data!["pharmacies"];
                if (pharmacy!.isEmpty) {
                  return no_appointment_found(title: "no pharmacy found");
                }
                _offset += pharmacy.length;
                return Expanded(
                    child: AnimationLimiter(
                        child: RefreshIndicator(
                  onRefresh: () async {},
                  backgroundColor: Constants.primcolor,
                  child: ListView.builder(
                    itemCount: pharmacy.length + (result.isLoading ? 1 : 0),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == pharmacy.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: ElevatedButton(
                              child: Text('Load More'),
                              onPressed: result.isLoading
                                  ? null
                                  : () {
                                      refetch!();
                                    },
                            ),
                          ),
                        );
                      }
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: const Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 200),
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: GestureDetector(
                                onTap: () => Get.toNamed("/pharmdetail"),
                                child: pharmacy_card(
                                  image: pharmacy[index]["logo_image"]["url"],
                                  id: pharmacy[index]["id"],
                                  location: pharmacy[index]["address"]
                                      ["location"],
                                  name: pharmacy[index]["name"],
                                  rate: pharmacy[index]["rate"],
                                  owner_name: pharmacy[index]
                                      ["owner_information"]["full_name"],
                                  owner_image: pharmacy[index]
                                      ["owner_information"]["image"]["url"],
                                  phone_number: pharmacy[index]["phone_number"],
                                  open_time: pharmacy[index]["open_time"],
                                  close_time: pharmacy[index]["close_time"],
                                )),
                          ),
                        ),
                      );
                    },
                  ),
                )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
