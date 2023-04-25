import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hakimea/apiservice/mymutation.dart';
import 'package:hakimea/utils/constants.dart';

class BlogDetail extends StatefulWidget {
  BlogDetail({super.key});

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  var blog = Get.arguments;
  late int like;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    like = blog["like"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            automaticallyImplyLeading: false,
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
            actions: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FaIcon(
                  FontAwesomeIcons.bookmark,
                  color: Constants.primcolor,
                ),
              )
            ],
            elevation: 0,
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: blog["image"],
                width: Get.width,
                height: 200,
                placeholder: (context, url) => const Icon(Icons.image),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            fillOverscroll: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Text(
                      blog["title"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(blog["doc_image"]),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "DR, ${blog["doc_name"]}",
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 10),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(like.toString()),
                          Mutation(
                            options: MutationOptions(
                              document: gql(Mymutation.like_blog),
                              onCompleted: (data) {
                                setState(() {
                                  like = like + 1;
                                });
                              },
                            ),
                            builder: (runMutation, result) {
                              return IconButton(
                                  onPressed: () async {
                                    runMutation({"id": blog["id"]});
                                  },
                                  icon: const Icon(
                                    Icons.thumb_up,
                                    color: Constants.primcolor,
                                  ));
                            },
                          ),
                          Text("0"),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.comment,
                                color: Constants.primcolor,
                              ))
                        ],
                      )
                    ],
                  ),
                  Text(
                    blog["date"],
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    child: Text(
                      blog["sub_title"],
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    blog["content"],
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
