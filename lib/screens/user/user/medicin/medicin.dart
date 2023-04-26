import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/user_controllers/medcincontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/widgets/cool_loading.dart';
import 'package:hakimea/widgets/no_appointment_found.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/user_controllers/signupcontroller.dart';
import '../pharmacy/widget/pharmacy_shmmer.dart';

class Medicin extends StatelessWidget {
  Medicin({Key? key}) : super(key: key);

  TextEditingController _medsearchcontro = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.primcolor,
        title: const Text(
          "Medicines",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Get.find<MedicinController>().medicn_search_key.value == "";
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.white,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //search
          Container(
            height: 100,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Constants.primcolor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: TextFormField(
              controller: _medsearchcontro,
              keyboardType: TextInputType.text,
              enabled: true,
              autofocus: false,
              onChanged: (newValue) {
                Get.find<MedicinController>()
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
                  hintText: "search medicine",
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
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Constants.whitesmoke),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  fillColor: Colors.white),
            ),
          ),
          // list of medicins
          Obx(() => Query(
                options:
                    Get.find<MedicinController>().medicn_search_key.value == ""
                        ? QueryOptions(
                            document: gql(Myquery.all_medicins),
                          )
                        : QueryOptions(
                            document: gql(Myquery.search_medicin),
                            variables: {
                                "name":
                                    "%${Get.find<MedicinController>().medicn_search_key.value}%"
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
                  List? medicins = result.data!["medicine"];

                  if (medicins!.isEmpty) {
                    return no_appointment_found(title: "No medicin found!");
                  }

                  return Expanded(
                    child: AnimationLimiter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AlignedGridView.count(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          itemCount: medicins.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredGrid(
                                position: index,
                                columnCount: 1,
                                child: ScaleAnimation(
                                    child: FadeInAnimation(
                                        child: Container(
                                  width: Get.width,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: InstaImageViewer(
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://media.istockphoto.com/id/606218650/fr/photo/m%C3%A9dicaments.webp?s=1024x1024&w=is&k=20&c=LINctpwKDi-5uqKcQ1z33JwXz8phdkH-V_SC9jPWNvM=",
                                          width: 70,
                                          height: 70,
                                          placeholder: (context, url) =>
                                              const Icon(Icons.image),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Flexible(
                                        child: Text(medicins[index]["name"])),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(medicins[index]
                                            ["medicine_pharmacy"]["name"]),
                                        Text(medicins[index]
                                                ["medicine_pharmacy"]["address"]
                                            ["location"]),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "ETB ${medicins[index]["price"]}",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          launch(
                                              "tel:${medicins[index]["medicine_pharmacy"]["phone_number"]}");
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.phone,
                                          color: Constants.primcolor,
                                        )),
                                  ),
                                ))));
                          },
                        ),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
