import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hakimea/utils/constants.dart';

class VoiceHistoryDetail extends StatelessWidget {
  VoiceHistoryDetail({Key? key}) : super(key: key);

  var doc_prof = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.whitesmoke,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: Colors.black,
            )),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.download,
                    color: Colors.black,
                    size: 14,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("download")
                ],
              )),
              PopupMenuItem(
                  child: Row(
                children: const [
                  FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                    size: 14,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "delete",
                    style: TextStyle(color: Colors.red),
                  )
                ],
              )),
            ],
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 100,
              width: Get.width,
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: doc_prof["image"],
                      width: 75,
                      height: 75,
                      placeholder: (context, url) => const Icon(Icons.image),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text("Dr.${doc_prof["name"]}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: 1,
                          color: Colors.black12,
                        ),
                        const Text(
                          "Voice call",
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          doc_prof["date"],
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 13),
                        ),
                      ],
                    ),
                    trailing: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Constants.primcolor.withOpacity(0.3)),
                        child: const Center(
                            child: FaIcon(
                          FontAwesomeIcons.phone,
                          color: Constants.primcolor,
                          size: 15,
                        ))),
                  ))
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              thickness: 1,
              color: Colors.black12,
            ),
            const Text(
              "30 min of voce call have been recorded",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: Get.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: ElevatedButton.icon(
                    icon: const FaIcon(
                      FontAwesomeIcons.play,
                      size: 16,
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)),
                    onPressed: () {},
                    label: const Text("Play voice recording")),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton.icon(
                        icon: const FaIcon(
                          FontAwesomeIcons.stop,
                          size: 16,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15)),
                        onPressed: () {},
                        label: const Text("Stop")),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ElevatedButton.icon(
                        icon: const FaIcon(
                          FontAwesomeIcons.pause,
                          size: 16,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15)),
                        onPressed: () {},
                        label: const Text("Pause")),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
