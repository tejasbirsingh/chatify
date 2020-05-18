import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmering extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      child: Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.white,
        child: Image.asset("assets/no_image.png"),
      ),
    );
  }
}
