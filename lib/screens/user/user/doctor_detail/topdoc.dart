import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/myquery.dart';

import '../../../../utils/constants.dart';
import '../../../../widgets/someting_went_wrong.dart';
import '../homepage/widgets/available_doctor.dart';
import '../homepage/widgets/onlinedocshimmer.dart';

class TopDoc extends StatelessWidget {
  const TopDoc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.whitesmoke,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const FaIcon(
                FontAwesomeIcons.angleLeft,
                color: Colors.black,
              )),
          title: const Text(
            "Top Doctor",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Query(
          options: QueryOptions(
            document: gql(Myquery.topdoctor),
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException) {
              return const someting_went_wrong();
            }
            if (result.isLoading) {
              return AlignedGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const OnlinedocShimmer();
                  });
            }
            List? doctors = result.data!["doctors"];
            if (doctors!.isEmpty) {
              return SizedBox(
                width: Get.width,
                height: Get.height,
                child:
                    const Center(child: Text("No doctor avallble right now!")),
              );
            }
            return AnimationLimiter(
              child: AlignedGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                      position: index,
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 300),
                      columnCount: 2,
                      child: ScaleAnimation(
                          child: FadeInAnimation(
                              child: available_doctor(
                        id: doctors[index]["id"],
                        name: doctors[index]["full_name"],
                        exp_year: doctors[index]["experience_year"],
                        image: doctors[index]["profile_image"]["url"],
                        speciality: doctors[index]["speciallities"]
                            ["speciallity_name"],
                        rate: double.parse(doctors[index]["rate"].toString()),
                        rate_count: doctors[index]["reviews"] == []
                            ? 0
                            : doctors[index]["reviews"].length,
                        is_online: doctors[index]["is_online"],
                      ))));
                },
              ),
            );
          },
        ));
  }
}
