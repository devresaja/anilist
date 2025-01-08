// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Blink extends StatelessWidget {
  const Blink({
    required this.height,
    required this.width,
    super.key,
    this.borderRadius,
    this.radius,
    this.isRounded = true,
    this.isCircle = false,
  });

  final double height;
  final double width;
  final BorderRadiusGeometry? borderRadius;
  final double? radius;
  final bool isRounded;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius ??
                (isRounded
                    ? BorderRadius.all(Radius.circular(radius ?? 12))
                    : (isCircle
                        ? const BorderRadius.all(Radius.circular(300))
                        : BorderRadius.zero))),
        height: height,
        width: width,
      ),
    );
  }
}
