import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/screens/user/user/blog/widgests/blog_card.dart';
import 'package:hakimea/screens/user/user/blog/widgests/blogshimmer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../apiservice/myquery.dart';
import '../../../../utils/constants.dart';

class AllBlog extends StatelessWidget {
  const AllBlog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  "Let`s",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Read a Blog",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //search blog
              TextFormField(
                keyboardType: TextInputType.text,
                enabled: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "search",
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
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.whitesmoke),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.whitesmoke),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.whitesmoke),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    fillColor: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              // top article
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "top_article".tr,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
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
                      return AnimationLimiter(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: blogs.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: const Duration(microseconds: 200),
                                duration: const Duration(microseconds: 500),
                                child: ScaleAnimation(
                                    child: FadeInAnimation(
                                        child: GestureDetector(
                                  onTap: () =>
                                      Get.toNamed("/blogdetail", arguments: {
                                    "id": blogs[index]["id"],
                                    "title": blogs[index]["title"],
                                    "sub_title": blogs[index]["sub_title"],
                                    "content": blogs[index]["content"],
                                    "image": blogs[index]["theImage"]["url"],
                                    "like": blogs[index]["like"],
                                    "doc_name": blogs[index]["doctor"]
                                        ["full_name"],
                                    "date": blogs[index]["created_at"]
                                        .substring(0, 10),
                                    "doc_image": blogs[index]["doctor"]
                                        ["profile_image"]["url"],
                                  }),
                                  child: BlogCard(
                                    id: blogs[index]["id"],
                                    title: blogs[index]["title"],
                                    sub_title: blogs[index]["sub_title"],
                                    content: blogs[index]["content"],
                                    image: blogs[index]["theImage"]["url"],
                                    like: blogs[index]["like"],
                                    doc_name: blogs[index]["doctor"]
                                        ["full_name"],
                                    date: blogs[index]["created_at"],
                                    doc_image: blogs[index]["doctor"]
                                        ["profile_image"]["url"],
                                  ),
                                ))));
                          },
                        ),
                      );
                    },
                  )),
              // all articles
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Tranding Blogs",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: Get.width,
                  child: Query(
                    options: QueryOptions(
                        document: gql(Myquery.all_articles),
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
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: List.generate(4, (index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              width: Get.width,
                              height: 255,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: Get.width,
                                      height: 170,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20))),
                                    ),
                                  ),
                                ],
                              ),
                            );
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
                      return AnimationLimiter(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: blogs.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: const Duration(microseconds: 200),
                                duration: const Duration(microseconds: 500),
                                child: ScaleAnimation(
                                    child: FadeInAnimation(
                                        child: GestureDetector(
                                            onTap: () => Get.toNamed(
                                                    "/blogdetail",
                                                    arguments: {
                                                      "id": blogs[index]["id"],
                                                      "title": blogs[index]
                                                          ["title"],
                                                      "sub_title": blogs[index]
                                                          ["sub_title"],
                                                      "content": blogs[index]
                                                          ["content"],
                                                      "image": blogs[index]
                                                          ["theImage"]["url"],
                                                      "like": blogs[index]
                                                          ["like"],
                                                      "doc_name": blogs[index]
                                                              ["doctor"]
                                                          ["full_name"],
                                                      "date": blogs[index]
                                                              ["created_at"]
                                                          .substring(0, 10),
                                                      "doc_image": blogs[index]
                                                                  ["doctor"]
                                                              ["profile_image"]
                                                          ["url"],
                                                    }),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 5),
                                              width: Get.width,
                                              height: 255,
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: blogs[index]
                                                          ["theImage"]["url"],
                                                      width: Get.width,
                                                      height: 170,
                                                      placeholder: (context,
                                                              url) =>
                                                          const Icon(
                                                              Icons.image),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    blogs[index]["title"],
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .visible),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 10,
                                                        backgroundImage:
                                                            NetworkImage(blogs[
                                                                            index]
                                                                        [
                                                                        "doctor"]
                                                                    [
                                                                    "profile_image"]
                                                                ["url"]),
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Text(
                                                        "DR, ${blogs[index]["doctor"]["full_name"]}",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25),
                                                    child: Text(
                                                      blogs[index]["created_at"]
                                                          .substring(0, 10),
                                                      style: const TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )))));
                          },
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
