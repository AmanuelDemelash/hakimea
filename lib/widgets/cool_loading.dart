import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';

class cool_loding extends StatelessWidget {
  const cool_loding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.width,
        child: Center(
          child: SpinKitThreeBounce(
            size: 40,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index.isEven
                      ? Constants.primcolor.withOpacity(0.3)
                      : Constants.primcolor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
