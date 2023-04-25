import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SpecialityShimmer extends StatelessWidget {
  const SpecialityShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Container(
        width: 120,
        height: 50,
        margin: const EdgeInsets.only(right: 6),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
        ),
      ),
    );
  }
}
