import 'package:flutter/material.dart';
import 'package:get/get.dart';

class someting_went_wrong extends StatelessWidget {
  const someting_went_wrong({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 50,
            ),
            Image(
              image: AssetImage(
                "assets/images/no_data.png",
              ),
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
            Text(
              "someting went wrong !",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
