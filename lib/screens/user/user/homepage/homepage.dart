import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/utils/constants.dart';
import 'package:hakimea/screens/user/user/homepage/widgets/available_doctor.dart';
import 'package:hakimea/screens/user/user/homepage/widgets/homepagechoiceitem.dart';
import 'package:hakimea/screens/user/user/homepage/widgets/topdoctors.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../apiservice/myquery.dart';
import '../../../../controllers/splashcontroller.dart';
import '../../../../controllers/user_controllers/homepagecontroller.dart';
import '../blog/widgests/blog_card.dart';
import '../blog/widgests/blogshimmer.dart';
import 'widgets/onlinedocshimmer.dart';
import 'widgets/topdocshimmer.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          //
          SliverAppBar(
            backgroundColor: Constants.whitesmoke,
            elevation: 10,
            pinned: false,
            floating: false,
            automaticallyImplyLeading: false,
            leading:
                Get.find<SplashController>().prefs.getString("token") == null
                    ? null
                    : IconButton(
                        onPressed: () {
                          Get.find<HomePageController>()
                              .advancedDrawerController
                              .showDrawer();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.barsStaggered,
                          color: Colors.black,
                        )),
            title: const Text(
              Constants.app_name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
            actions: [
              Get.find<SplashController>().prefs.getString("token") == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: GestureDetector(
                        onTap: () => Get.offAllNamed("/login"),
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.toNamed("/favorite");
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.black,
                            )),
                        // notification
                        IconButton(
                            onPressed: () {
                              Get.toNamed("/notification");
                            },
                            icon: Query(
                              options: QueryOptions(
                                  document: gql(Myquery.notification),
                                  variables: {
                                    "id": Get.find<SplashController>()
                                        .prefs
                                        .getInt("id")
                                  }),
                              builder: (result, {fetchMore, refetch}) {
                                if (result.hasException) {
                                  return const FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.black,
                                  );
                                }
                                if (result.isLoading) {
                                  return const FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.black,
                                  );
                                }
                                List? notifi = result.data!["notifications"];
                                return Badge(
                                  showBadge: notifi!.isEmpty ? false : true,
                                  badgeColor: Colors.red,
                                  shape: BadgeShape.circle,
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  position:
                                      BadgePosition.topEnd(top: -13, end: -10),
                                  badgeContent: Text(
                                    notifi.length.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: const FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            )),
                        //cart
                        IconButton(
                            onPressed: () {
                              Get.toNamed("/myorder");
                            },
                            icon: Query(
                              options: QueryOptions(
                                  document: gql(Myquery.not_order),
                                  variables: {
                                    "id": Get.find<SplashController>()
                                        .prefs
                                        .getInt("id")
                                  }),
                              builder: (result, {fetchMore, refetch}) {
                                if (result.hasException) {
                                  return const FaIcon(
                                    FontAwesomeIcons.cartShopping,
                                    color: Colors.black,
                                  );
                                }
                                if (result.isLoading) {
                                  return const FaIcon(
                                    FontAwesomeIcons.cartShopping,
                                    color: Colors.black,
                                  );
                                }
                                List? notifi = result.data!["orders"];
                                return Badge(
                                  showBadge: notifi!.isEmpty ? false : true,
                                  badgeColor: Colors.red,
                                  shape: BadgeShape.circle,
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  position:
                                      BadgePosition.topEnd(top: -13, end: -10),
                                  badgeContent: Text(
                                    notifi.length.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  child: const FaIcon(
                                    FontAwesomeIcons.prescription,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            )),
                      ],
                    )
            ],
          ),
          SliverFillRemaining(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    //haakime banner
                    Container(
                      height: 150,
                      width: Get.width,
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            height: 100,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Constants.primcolor,
                                  Constants.primcolor.withOpacity(0.5)
                                ]),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "---",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      key:const Key("bantext"),
                                      'ban_title'.tr,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      'ban_sub_title'.tr,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    )
                                  ],
                                ),
                                const Image(
                                  image: AssetImage(
                                      "assets/images/splash_logo.png"),
                                  width: 50,
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () => Get.toNamed("/docsearch"),
                                child: TextField(
                                  enabled: false,
                                  decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.search),
                                      border: InputBorder.none,
                                      hintText: 'search'.tr),
                                ),
                              )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.menu_open_rounded))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Get.width,
                      height: 100,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed("/doctor");
                              },
                              child: homepage_choice(
                                  title: "doc",
                                  path: "assets/images/doctor.png"),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed("/pharmacy");
                              },
                              child: homepage_choice(
                                title: "pharmacy",
                                path: "assets/images/pharmacy.png",
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed("/medicin");
                              },
                              child: homepage_choice(
                                  title: "medicine",
                                  path: "assets/images/medicine.png"),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: homepage_choice(
                                  title: "Lab", path: "assets/images/lab.png"),
                            ),
                          ]),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      width: Get.width,
                      height: 100,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: homepage_choice(
                                title: "Ambulance",
                                path: "assets/images/ambu.png"),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/presc");
                            },
                            child: homepage_choice(
                                title: "Prescription",
                                path: "assets/images/medical-prescription.png"),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'top doc'.tr,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed("/topdoc");
                                },
                                child: Text(
                                  "see all".tr,
                                  style: const TextStyle(
                                      color: Constants.primcolor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const FaIcon(
                                FontAwesomeIcons.angleRight,
                                size: 14,
                                color: Constants.primcolor,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // top doctors
                    SizedBox(
                        width: Get.width,
                        height: 230,
                        child: Query(
                            options: QueryOptions(
                              document: gql(Myquery
                                  .topdoctor), // this is the query string you just created
                            ),
                            builder: (QueryResult result,
                                {VoidCallback? refetch, FetchMore? fetchMore}) {
                              if (result.hasException) {
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(4, (index) {
                                    return const TopdocShimmer();
                                  }),
                                );
                              }
                              if (result.isLoading) {
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(4, (index) {
                                    return const TopdocShimmer();
                                  }),
                                );
                              }
                              List? doctors = result.data?['doctors'];
                              if (doctors!.isEmpty) {
                                return const Center(
                                  child: Text("no top doc found"),
                                );
                              }
                              return ListView.builder(
                                itemCount: doctors.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => top_doctors(
                                  id: doctors[index]["id"],
                                  image: doctors[index]["profile_image"]["url"],
                                  name: doctors[index]["full_name"],
                                  speciality: doctors[index]["speciallities"]
                                      ["speciallity_name"],
                                  rate: double.parse(
                                      doctors[index]["rate"].toString()),
                                ),
                              );
                            })),
                    // banners
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "your adds hear".tr,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: Get.width,
                      height: 170,
                      child: Query(
                        options: QueryOptions(
                            document: gql(Myquery.banners),
                            pollInterval: const Duration(seconds: 10)),
                        builder: (result, {fetchMore, refetch}) {
                          if (result.hasException) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.white,
                              child: Container(
                                width: Get.width,
                                height: 150,
                                margin: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                              ),
                            );
                          }
                          if (result.isLoading) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade200,
                              highlightColor: Colors.white,
                              child: Container(
                                width: Get.width,
                                height: 150,
                                margin: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                              ),
                            );
                          }
                          List? banners = result.data!["banners"];
                          if (banners!.isEmpty) {
                            return const Center(
                                child: Text(
                              "no banners yet",
                              style: TextStyle(color: Colors.black54),
                            ));
                          }
                          return Column(
                            children: [
                              CarouselSlider.builder(
                                itemCount: result.data!["banners"].length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    Container(
                                  height: 150,
                                  width: Get.width,
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white),
                                  margin: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: banners[itemIndex]["the_image"]
                                          ["url"],
                                      width: Get.width,
                                      height: 150,
                                      placeholder: (context, url) => Icon(
                                        Icons.image,
                                        color: Constants.primcolor
                                            .withOpacity(0.5),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                options: CarouselOptions(
                                  autoPlay: true,
                                  height: 150,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) =>
                                      Get.find<HomePageController>()
                                          .slider_indicator
                                          .value = index,
                                ),
                              ),
                              SizedBox(
                                width: Get.width,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                        result.data!["banners"].length,
                                        (index) => Obx(
                                              () => AnimatedContainer(
                                                duration: const Duration(
                                                    microseconds: 100),
                                                width: 8,
                                                height: 8,
                                                margin: const EdgeInsets.only(
                                                    left: 2, right: 2),
                                                decoration: BoxDecoration(
                                                    color: Get.find<HomePageController>()
                                                                .slider_indicator
                                                                .value ==
                                                            index
                                                        ? Constants.primcolor
                                                        : Colors.black54,
                                                    shape: BoxShape.circle),
                                              ),
                                            ))),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // blogs
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "top_article".tr,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Get.toNamed("/allblog"),
                                  child: Text(
                                    "see all".tr,
                                    style: const TextStyle(
                                        color: Constants.primcolor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                const FaIcon(
                                  FontAwesomeIcons.angleRight,
                                  size: 14,
                                  color: Constants.primcolor,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: Get.width,
                        height: 170,
                        child: Query(
                          options: QueryOptions(
                              document: gql(Myquery.top_articles),
                              pollInterval: const Duration(seconds: 10)),
                          builder: (result, {fetchMore, refetch}) {
                            if (result.hasException) {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(4, (index) {
                                  return const BlogShimmer();
                                }),
                              );
                            }
                            if (result.isLoading) {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(4, (index) {
                                  return const BlogShimmer();
                                }),
                              );
                            }
                            List? blogs = result.data!["blogs"];
                            if (blogs!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "no top blogs found ",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: blogs.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () =>
                                        Get.toNamed("/blogdetail", arguments: {
                                          "id": blogs[index]["id"],
                                          "title": blogs[index]["title"],
                                          "sub_title": blogs[index]
                                              ["sub_title"],
                                          "content": blogs[index]["content"],
                                          "image": blogs[index]["theImage"]
                                              ["url"],
                                          "like": blogs[index]["like"],
                                          "doc_name": blogs[index]["doctor"]
                                              ["full_name"],
                                          "date": blogs[index]["created_at"]
                                              .substring(0, 10),
                                          "doc_image": blogs[index]["doctor"]
                                              ["profile_image"]["url"],
                                        }),
                                    child: BlogCard(
                                      date: blogs[index]["created_at"],
                                      id: blogs[index]["id"],
                                      title: blogs[index]["title"],
                                      sub_title: blogs[index]["sub_title"],
                                      content: blogs[index]["content"],
                                      image: blogs[index]["theImage"]["url"],
                                      like: blogs[index]["like"],
                                      doc_name: blogs[index]["doctor"]
                                          ["full_name"],
                                      doc_image: blogs[index]["doctor"]
                                          ["profile_image"]["url"],
                                    ));
                              },
                            );
                          },
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    // online doctor
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "available doctors".tr,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                "see all".tr,
                                style: const TextStyle(
                                    color: Constants.primcolor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const FaIcon(
                                FontAwesomeIcons.angleRight,
                                size: 14,
                                color: Constants.primcolor,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: Get.width,
                        child: Query(
                          options: QueryOptions(
                            document: gql(Myquery.onlinedoctor),
                          ),
                          builder: (result, {fetchMore, refetch}) {
                            if (result.hasException) {
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
                                child: const Center(
                                    child:
                                        Text("No doctor avallble right now!")),
                              );
                            }
                            return AlignedGridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              itemCount: doctors.length,
                              itemBuilder: (context, index) {
                                return available_doctor(
                                  id: doctors[index]["id"],
                                  name: doctors[index]["full_name"],
                                  exp_year: doctors[index]["experience_year"],
                                  image: doctors[index]["profile_image"]["url"],
                                  speciality: doctors[index]["speciallities"]
                                      ["speciallity_name"],
                                  rate: double.parse(
                                      doctors[index]["rate"].toString()),
                                  rate_count: doctors[index]["reviews"] == []
                                      ? 0
                                      : doctors[index]["reviews"].length,
                                  is_online: doctors[index]["is_online"],
                                );
                              },
                            );
                          },
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
