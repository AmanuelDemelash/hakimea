import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BlogCard extends StatelessWidget {
  int id;
  String title;
  String sub_title;
  String image;
  String content;
  int like;
  String doc_image;
  String doc_name;
  String date;
  BlogCard(
      {Key? key,
      required this.id,
      required this.title,
      required this.sub_title,
      required this.image,
      required this.content,
      required this.like,
      required this.doc_image,
      required this.date,
      required this.doc_name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 1.2,
      height: 170,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: image,
              width: 100,
              height: 170,
              placeholder: (context, url) => const Icon(Icons.image),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Flexible(
                            child: Text(
                          title,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flexible(
                            child: Text(
                          sub_title,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(doc_image),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "DR, $doc_name",
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        date.substring(0, 10),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    const FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(like.toString()),
                    //comment
                    const SizedBox(
                      width: 10,
                    ),
                    const FaIcon(
                      FontAwesomeIcons.comment,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text("")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
