import 'package:emoji_alert/arrays.dart';
import 'package:emoji_alert/emoji_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/apiservice/myquery.dart';
import 'package:hakimea/controllers/splashcontroller.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/screens/user/user/favorite/widgets/favorite_doctor_card.dart';
import 'package:hakimea/widgets/cool_loading.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.whitesmoke,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Center(
              child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
            ),
          )),
          title: const Text(
            "My Favorite Doctors",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Get.find<SplashController>().prefs.getString("token") == null
            ? SizedBox(
                width: Get.width,
                height: Get.height,
                child: Center(
                  child: EmojiAlert(
                    alertTitle: const Text("Login",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    description: Column(
                      children: const [
                        Text("You need to login first"),
                      ],
                    ),
                    enableMainButton: true,
                    mainButtonColor: Constants.primcolor,
                    onMainButtonPressed: () {
                      Navigator.pop(context);
                      Get.offAllNamed("/login");
                    },
                    cancelable: true,
                    emojiType: EMOJI_TYPE.SAD,
                    height: 260,
                    mainButtonText: const Text("OK"),
                    animationType: ANIMATION_TYPE.ROTATION,
                  ),
                ))
            : Query(
                options: QueryOptions(
                    document: gql(Myquery.fav_doctor),
                    variables: {
                      "id": Get.find<SplashController>().prefs.getInt("id")
                    },
                    pollInterval: const Duration(seconds: 10)),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    print(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return const Center(
                      child: cool_loding(),
                    );
                  }
                  List? favdoc = result.data!["favorite"];
                  if (favdoc!.isEmpty) {
                    return const Center(
                      child: Text(
                        "no favorite doctor found",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          AnimationLimiter(
                              child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: favdoc.length,
                            itemBuilder: (context, index) {
                              return Mutation(
                                  options: MutationOptions(
                                    document: gql(Mymutation.delete_fav_doc),
                                    onCompleted: (data) {
                                      //favdoc.removeAt(index);
                                    },
                                  ),
                                  builder: (runMutation, result) {
                                    if (result!.hasException) {
                                      print(result.exception.toString());
                                    }
                                    if (result.isLoading) {
                                      favdoc.removeAt(index);
                                      return const Center(
                                        child: cool_loding(),
                                      );
                                    }
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                                child: Dismissible(
                                                    direction: DismissDirection
                                                        .horizontal,
                                                    key: UniqueKey(),
                                                    onDismissed: (direction) {
                                                      if (direction ==
                                                          DismissDirection
                                                              .endToStart) {
                                                        // run delet mutation
                                                        runMutation({
                                                          "id": favdoc[index]
                                                              ["id"]
                                                        });
                                                      }
                                                    },
                                                    child: favorite_doctor_card(
                                                      image: favdoc[index]
                                                                  ["doctor"]
                                                              ["profile_image"]
                                                          ["url"],
                                                      name: favdoc[index]
                                                              ["doctor"]
                                                          ["full_name"],
                                                      spec: favdoc[index]
                                                                  ["doctor"]
                                                              ["speciallities"]
                                                          ["speciallity_name"],
                                                    )))));
                                  });
                            },
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
