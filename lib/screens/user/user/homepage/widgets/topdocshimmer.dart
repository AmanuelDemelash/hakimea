

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TopdocShimmer extends StatelessWidget {
  const TopdocShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        Container(
          width: 150,
          height: 210,
          margin: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.white,
                child: Container(
                  width: 150,
                  height: 130,
                  decoration:const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),topLeft: Radius.circular(10),topRight: Radius.circular(10))
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),

                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.white,
                        child: Container(
                          width:130,
                          height: 15,
                          margin: const EdgeInsets.only(right: 10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.white,
                        child: Container(
                          width: 100,
                          height:15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

        );

  }
}
